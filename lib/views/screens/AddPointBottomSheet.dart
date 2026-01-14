import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/core/utils/snackbar_helper.dart';
import 'package:nadi_user_app/services/points_request.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';

enum RecipientType { admin, friend }

class AddPointBottomSheetContent extends StatefulWidget {
  const AddPointBottomSheetContent({super.key});

  @override
  State<AddPointBottomSheetContent> createState() =>
      _AddPointBottomSheetContentState();
}

class _AddPointBottomSheetContentState
    extends State<AddPointBottomSheetContent> {
  RecipientType _selectedType = RecipientType.admin;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final PointsRequest _pointsRequest = PointsRequest();
  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    AppLogger.warn("FORM VALIDATED ");

    final points = _pointsController.text.trim();
    final mobile = _mobileController.text.trim();
    final reason = _notesController.text.trim();
    AppLogger.warn("Submitting points=$points, mobile=$mobile");

    if (_selectedType == RecipientType.admin) {
        setState(() => isLoading = true);
        try{
         final result = await _pointsRequest.sendtoadmin(points: points);
                 setState(() => isLoading = false);
        AppLogger.warn("API SUCCESS: $result");
        SnackbarHelper.ShowSuccess(context, "Points request sent successfully");
          Navigator.pop(context);
        }catch(e){
        AppLogger.error("API ERROR: $e");
        setState(() => isLoading = false);
        SnackbarHelper.showError(context, e.toString());
        }

    } else {
      try {
        setState(() => isLoading = true);
        final result = await _pointsRequest.sendtofriend(
          mobileNumber: mobile,
          points: points,
          reason:reason,
        );
        setState(() => isLoading = false);
        AppLogger.warn("API SUCCESS: $result");
        SnackbarHelper.ShowSuccess(context, "Points request sent successfully");
        Navigator.pop(context);
      } catch (e) {
        AppLogger.error("API ERROR: $e");
        setState(() => isLoading = false);
        SnackbarHelper.showError(context, e.toString());
      }
    }
  }

  @override
  void dispose() {
    _pointsController.dispose();
    _notesController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: true,
      initialChildSize: 0.75,
      minChildSize: 0.50,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              /// Drag handle
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              /// Title
              const Text(
                "Request To Points",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              /// RADIO BUTTON ROW
              Row(
                children: [
                  Expanded(
                    child: ListTileTheme(
                      horizontalTitleGap: 0,
                      dense: true,
                      child: RadioListTile<RecipientType>(
                        contentPadding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        title: const Text("Admin"),
                        value: RecipientType.admin,
                        activeColor: AppColors.btn_primery,
                        groupValue: _selectedType,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                            _mobileController.clear();
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTileTheme(
                      horizontalTitleGap: 0,
                      dense: true,
                      child: RadioListTile<RecipientType>(
                        contentPadding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        title: const Text("Friend"),
                        value: RecipientType.friend,
                        activeColor: AppColors.btn_primery,
                        groupValue: _selectedType,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    /// Mobile Number (Disabled for Admin)
                    reuseTextField(
                      controller: _mobileController,
                      hintText: "Mobile Number*",
                      prefix: "+973 ",
                      keyboardType: TextInputType.phone,
                      enabled: _selectedType == RecipientType.friend,
                      validator: (value) {
                        if (_selectedType == RecipientType.friend) {
                          if (value == null || value.isEmpty) {
                            return "Mobile number required";
                          }
                          if (value.length < 8) {
                            return "Enter valid mobile number";
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    /// Points
                    reuseTextField(
                      controller: _pointsController,
                      hintText: "Enter Points*",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Points required";
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return "Enter valid points";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Enter a positive integer value for the points.",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 25),

                    /// Notes
                    const Text(
                      "Notes (Optional)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    reuseTextField(
                      hintText: "For new service request.",
                      controller: _notesController,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),

              /// Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: "Cancel",
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      color: Colors.grey.shade400,
                      width: 150,
                      height: 48,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      text: "Submit",
                      isLoading: isLoading,
                      onPressed: _handleSubmit,
                      color: const Color.fromRGBO(213, 155, 8, 1),
                      height: 48,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget reuseTextField({
    TextEditingController? controller,
    required String hintText,
    bool enabled = true,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    String? prefix,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: hintText,
        prefixText: prefix,
        floatingLabelStyle: TextStyle(color: AppColors.btn_primery),
        filled: !enabled,
        fillColor: !enabled ? Colors.grey.shade200 : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.btn_primery),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
