import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/controllers/address_controller.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/core/utils/snackbar_helper.dart';
import 'package:nadi_user_app/l10n/app_localizations.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/providers/auth_Provider.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/services/auth_service.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';
import 'package:nadi_user_app/widgets/inputs/app_dropdown.dart';
import 'package:nadi_user_app/widgets/inputs/app_text_field.dart';

class Address extends StatefulWidget {
  final String accountType;
  final VoidCallback? onNext;
  final bool family;
  final GlobalKey<FormState> formKey;
  final AddressController controller;
  const Address({
    super.key,
    required this.accountType,
    this.onNext,
    this.family = false,
    required this.formKey,
    required this.controller,
  });

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  String selected = "Flat";
  bool _isLoading = false;
  bool _hideBottomButton = false;
  final AuthService _adressservice = AuthService();
  AddressController get controller => widget.controller;
  Future<void> familyAccount(BuildContext context) async {
    final userId = await AppPreferences.getUserId();

    if (userId == null) {
      AppLogger.info(" USER ID IS NULL");
      return;
    }

    final body = controller.getApiAddressBody(
      userId: userId,
      addressType: selected.toLowerCase(),
    );

    // debugPrint(" API BODY  $body");
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _isLoading = true);
    });

    try {
      final response = await _adressservice.adressdetails(body: body);
      // API finished
      if (mounted) setState(() => _isLoading = false);

      if (response != null) {
        // debugPrint(" Address saved successfully");

        if (widget.accountType == "Family") {
          widget.onNext?.call();
        } else {
          setState(() {
            _hideBottomButton = true;
          });
          SnackbarHelper.ShowSuccess(context, "Account created successfully");

          // small delay so user can see snackbar
          Future.delayed(const Duration(seconds: 1), () {
            context.push(RouteNames.accountverfy);
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      SnackbarHelper.showError(context, "Submit failed: $e");
    }
  }

  Widget buildType(String type, String icon) {
    final bool isSelected = selected == type;

    return GestureDetector(
      onTap: () => setState(() => selected = type),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.btn_primery : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? null
              : Border.all(color: Colors.grey.shade400, width: 1),
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 24,
              width: 24,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            SizedBox(width: 6),
            Text(
              type,
              style: TextStyle(
                fontSize: 15,
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          AppTextField(
            controller: controller.building,
            label: l10n.pickLocation,
          ),
          SizedBox(height: 10),

          // if (widget.accountType == "Family") ...[
          //   AppTextField(label: l10n.enterNumberOfKids),
          //   SizedBox(height: 10),
          //   Row(
          //     children: [
          //       Expanded(child: AppTextField(label: l10n.noOfBoys)),
          //       SizedBox(width: 10),
          //       Expanded(child: AppTextField(label: l10n.noOfGirls)),
          //     ],
          //   ),
          //   SizedBox(height: 17),
          // ],
          SizedBox(height: 15),
          Image.asset("assets/images/map.png", height: 84),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildType(l10n.flat, 'assets/icons/Flat.png'),
              buildType(l10n.villa, 'assets/icons/villa.png'),
              // buildType(l10n.office, 'assets/icons/office.png'),
            ],
          ),
          SizedBox(height: 17),
          AppTextField(controller: controller.city, label: l10n.enterCity),
          SizedBox(height: 17),
          AppTextField(
            controller: controller.building,
            label: l10n.enterBuilding,
            validator: (value) => controller.validateBuilding(value),
          ),
          SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: controller.aptNo,
                  keyboardType: TextInputType.number,
                  label: l10n.enterAptNo,
                  validator: (value) => controller.validateAptNo(value),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: AppTextField(
                  controller: controller.floor,
                  keyboardType: TextInputType.number,
                  label: l10n.enterFloorNo,
                  validator: (value) => controller.validateFloor(value),
                ),
              ),
            ],
          ),
          SizedBox(height: 17),

          Consumer(
            builder: (context, ref, child) {
              final blockAsync = ref.watch(getBlockProvider);

              return blockAsync.when(
                data: (blocks) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// BLOCK FIRST
                      AppDropdown(
                        label: l10n.selectBlock,
                        items: blocks.map((b) => b['name'] as String).toList(),
                        value: controller.block,
                        onChanged: (val) {
                          setState(() {
                            final block = blocks.firstWhere(
                              (b) => b['name'] == val,
                            );
                            controller.block = block['name'];
                            controller.blockId = block['_id'];
                            controller.road = null;
                            controller.roadId = null;

                            controller.roadsForSelectedBlock =
                                List<Map<String, dynamic>>.from(block['roads']);
                          });
                        },
                        validator: (val) =>
                            val == null ? "Please select a block" : null,
                      ),

                      SizedBox(height: 15),

                      /// ROAD SECOND
                      AppDropdown(
                        label: l10n.selectRoad,
                        items: controller.roadsForSelectedBlock
                            .map((r) => r['name'] as String)
                            .toList(),
                        value: controller.road,
                        onChanged: (val) {
                          setState(() {
                            final road = controller.roadsForSelectedBlock
                                .firstWhere((r) => r['name'] == val);

                            controller.road = road['name'];
                            controller.roadId = road['_id'];
                          });
                        },
                        validator: (val) =>
                            val == null ? "Please select a road" : null,
                      ),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text("Failed to load blocks: $e"),
              );
            },
          ),

          SizedBox(height: 20),
          if (!widget.family)
            if (!_hideBottomButton)
              AppButton(
                text: widget.accountType == "Family"
                    ? l10n.continueBtn
                    : l10n.signIn,
                isLoading: _isLoading,
                onPressed: () {
                  final isValid =
                      widget.formKey.currentState?.validate() ?? false;

                  if (!isValid) return;
                  familyAccount(context);
                },
                color: AppColors.btn_primery,
                width: double.infinity,
              ),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}
