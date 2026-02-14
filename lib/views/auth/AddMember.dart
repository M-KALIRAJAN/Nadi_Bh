// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mannai_user_app/controllers/address_controller.dart';
// import 'package:mannai_user_app/controllers/family_member_controller.dart';

// import 'package:mannai_user_app/core/constants/app_consts.dart';
// import 'package:mannai_user_app/core/utils/logger.dart';
// import 'package:mannai_user_app/routing/app_router.dart';
// import 'package:mannai_user_app/services/auth_service.dart';
// import 'package:mannai_user_app/views/auth/individual/Address.dart';

// import 'package:mannai_user_app/widgets/buttons/primary_button.dart';
// import 'package:mannai_user_app/widgets/inputs/app_dropdown.dart';
// import 'package:mannai_user_app/widgets/inputs/app_text_field.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Addmember extends StatefulWidget {
//   final String accountType;
//   final VoidCallback onNext;
//   final GlobalKey<FormState> formKey;

//   const Addmember({
//     super.key,
//     required this.accountType,
//     required this.onNext,
//     required this.formKey,
//   });

//   @override
//   State<Addmember> createState() => _AddmemberState();
// }

// class _AddmemberState extends State<Addmember> {
//   bool _isAddress = false;
//   final controller = FamilyMemberController();
//   final addressController = AddressController();
//   final AuthService _authService = AuthService();
//   final GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();
// int _totalMembers = 0;
// int _currentMemberIndex = 1;
// List<Map<String, dynamic>> _members = [];
// bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
// bool _isLoading = false; // add this in your State class

// Future<void> AccountCreated(BuildContext context) async {
//   final memberValid = widget.formKey.currentState?.validate() ?? false;
//   if (!memberValid) {
//     debugPrint("MEMBER FORM INVALID");
//     return;
//   }

//   if (_isAddress) {
//     final addressValid = _addressFormKey.currentState?.validate() ?? false;
//     debugPrint("ADDRESS VALID = $addressValid");
//     if (!addressValid) {
//       debugPrint("ADDRESS FORM INVALID");
//       return;
//     }
//   }

//   debugPrint("ALL VALID — CONTINUING");

//   final prefs = await SharedPreferences.getInstance();
//   final userId = prefs.getString("userId");

//   debugPrint("USER ID = $userId");

//   if (userId == null) {
//     debugPrint("USER ID NULL");
//     return;
//   }

//   final addressMap = addressController.getOnlyAddressMap(
//     addressType: "flat",
//   );

//   final body = controller.getApiFamilyMemberBody(
//     userId: userId,
//     address: addressMap,
//   );

//   debugPrint("FINAL BODY  ${jsonEncode(body)}");

//   if (mounted) setState(() => _isLoading = true);

//   try {
//     final response = await _authService.memberdetails(body: body);

//     // API finished, stop loader
//     if (mounted) setState(() => _isLoading = false);

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: const Text(
//             "Account created successfully",
//             style: TextStyle(color: Colors.white),
//           ),
//           backgroundColor: AppColors.button_secondary,
//           duration: const Duration(seconds: 2),
//         ),
//       );

//     // small delay so user can see snackbar
//     Future.delayed(const Duration(seconds: 1), () {
//       context.push(RouteNames.accountverfy);
//     });

//     AppLogger.debug("RESPONSE 👉 ${jsonEncode(response)}");
//   } catch (e) {
//     if (mounted) setState(() => _isLoading = false); // stop loader on error
//     debugPrint("Address submit failed  $e");
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Submit failed: $e")));
//   }
// }

//     return Form(
//       key: widget.formKey,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,

//               children: [
//                 Text(
//                   "Add ${widget.accountType} Member",
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 AppTextField(
//                   controller: controller.familyCount,
//                   label: "Enter Family Count*",
//                   validator: (value) => controller.validatefamilycount(value),
//                 ),
//                 const SizedBox(height: 15),

//                 AppTextField(
//                   controller: controller.fullName,
//                   label: "Member Full Name*",
//                   validator: (value) => controller.validatefullname(value),
//                 ),

//                 const SizedBox(height: 15),
//                 AppDropdown(
//                   label: "Relationship*",
//                   items: ["Father", "Mother", "Son", "Daughter", "Spouse"],
//                   value: controller.relation,
//                   onChanged: (val) {
//                     setState(() {
//                       controller.relation = val;
//                     });
//                   },
//                   validator: (val) =>
//                       val == null ? "Please select relationship" : null,
//                 ),

//                 const SizedBox(height: 15),

//                 AppTextField(
//                   controller: controller.mobile,
//                   label: "Mobile Number*",
//                   validator: (value) => controller.validatemobilenumber(value),
//                 ),

//                 const SizedBox(height: 15),
//                       AppTextField(
//                   controller: controller.password,
//                   label: "Password*",
//                   validator: (value) => controller.validatepassword(value),
//                 ),

//                 const SizedBox(height: 15),

//                 AppTextField(
//                   controller: controller.email,
//                   label: "Email Adress*",
//                   validator: (value) => controller.validateemail(value),
//                 ),
//                 const SizedBox(height: 20),
//                 AppDropdown(
//                   label: "Gender*",
//                   items: ["Male", "Female", "Oter"],
//                   value: controller.gender,
//                   onChanged: (val) {
//                     setState(() {
//                       controller.gender = val;
//                     });
//                   },
//                   validator: (val) =>
//                       val == null ? "Please select relationship" : null,
//                 ),

//                 const SizedBox(height: 20),

//                 if (_isAddress)
//                   Column(
//                     children: [
//                       const SizedBox(height: 20),
//                       Address(
//                         accountType: "Family",
//                         family: true,
//                         formKey: _addressFormKey,
//                         controller: addressController, //  pass controller
//                       ),
//                     ],
//                   ),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 47,
//                   child: OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _isAddress = !_isAddress;
//                       });
//                     },
//                     child: Text(
//                       _isAddress ? "Hide Address" : "Add Address",
//                       style: TextStyle(color: AppColors.btn_primery),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           AppButton(
//             text: "Sign Up",
//             isLoading: _isLoading,
//             onPressed: () {
//               AccountCreated(context);
//             },

//             color: AppColors.btn_primery,
//             width: double.infinity,
//             height: 47,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/controllers/address_controller.dart';
import 'package:nadi_user_app/controllers/family_member_controller.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/core/utils/snackbar_helper.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/services/auth_service.dart';
import 'package:nadi_user_app/views/auth/Address.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';
import 'package:nadi_user_app/widgets/inputs/app_dropdown.dart';
import 'package:nadi_user_app/widgets/inputs/app_text_field.dart';

class Addmember extends StatefulWidget {
  final String accountType;
  final VoidCallback onNext;
  final GlobalKey<FormState> formKey;

  const Addmember({
    super.key,
    required this.accountType,
    required this.onNext,
    required this.formKey,
  });

  @override
  State<Addmember> createState() => _AddmemberState();
}

class _AddmemberState extends State<Addmember> {
  final controller = FamilyMemberController();
  final addressController = AddressController();
  final AuthService _authService = AuthService();
  bool _isAddress = false;
  bool _isFamilyCountLocked = false;
  bool _hideBottomButton = false;
  final GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();

  bool _isLoading = false;

  int _totalMembers = 0;
  int _currentMemberIndex = 1;

  Future<void> _addMember() async {
    final memberValid = widget.formKey.currentState?.validate() ?? false;
    final addressValid = _addressFormKey.currentState?.validate() ?? false;

    if (!memberValid || !addressValid) return;

    // final prefs = await SharedPreferences.getInstance();
    // final userId = prefs.getString("userId");
    final userId = await AppPreferences.getUserId();
    if (userId == null) return;

    final body = controller.getApiFamilyMemberBody(
      userId: userId,
      address: _isAddress
          ? addressController.getOnlyAddressMap(addressType: "flat")
          : null,
    );
    AppLogger.success("body : $body");
    setState(() => _isLoading = true);

    try {
      final response = await _authService.memberdetails(body: body);
      setState(() => _isLoading = false);

      AppLogger.debug("Member added  ${jsonEncode(response)}");

      // Clear form for next member
      controller.fullName.clear();
      controller.mobile.clear();
      controller.email.clear();
      controller.password.clear();
      controller.relation = null;
      controller.gender = null;
      if (_isAddress) addressController.clear();

      // If last member
      if (_currentMemberIndex == _totalMembers) {
        setState(() {
          _hideBottomButton = true;
        });

        SnackbarHelper.ShowSuccess(context, "All members added successfully");

        // Delay slightly so user sees the snackbar
        Future.delayed(const Duration(seconds: 1), () {
          context.push(RouteNames.accountverfy);
        });
      } else {
        // Increment member index for next member
        setState(() {
          _currentMemberIndex++;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (e is DioException) {
        final errorMessage =
            e.response?.data['message'] ??
            e.response?.data.toString() ??
            "Something went wrong";

        SnackbarHelper.showError(context, errorMessage);
      } else {
        
        SnackbarHelper.showError(context, "Something went wrong");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "Add ${widget.accountType} Member",
                //   style: const TextStyle(
                //     fontSize: 22,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                if (_totalMembers > 0)
                  Text(
                    " Add ${widget.accountType}Member $_currentMemberIndex of $_totalMembers",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    SizedBox(
                      width: 160,
                      height: 45,
                      child: TextFormField(
                        controller: controller.familyCount,
                        keyboardType: TextInputType.number,
                        enabled: !_isFamilyCountLocked,
                        decoration: InputDecoration(
                          labelText: "Enter Family Count*",
                          labelStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.black26),
                          ),
                        ),
                        validator: controller.validatefamilycount,
                        onChanged: (val) {
                          final count = int.tryParse(val);
                          if (count != null && count > 0) {
                            setState(() {
                              _totalMembers = count;
                              _currentMemberIndex = 1;
                              _isFamilyCountLocked = true;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 1),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isFamilyCountLocked = false;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.person_add, size: 18,color: AppColors.btn_primery,),
                          const SizedBox(width: 4),
                          const Text("Add Member",style: TextStyle(color: AppColors.btn_primery),),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                const SizedBox(height: 15),

                AppTextField(
                  controller: controller.fullName,
                  label: "Member Full Name*",
                  validator: (value) => controller.validatefullname(value),
                ),
                const SizedBox(height: 15),

                AppDropdown(
                  label: "Relationship*",
                  items: const [
                    "Father",
                    "Mother",
                    "Son",
                    "Daughter",
                    "Add Other",
                  ],
                  value: controller.relation,
                  onChanged: (val) => setState(() => controller.relation = val),
                  validator: (val) =>
                      val == null ? "Select relationship" : null,
                ),

                const SizedBox(height: 15),

                // Mobile
                AppTextField(
                  controller: controller.mobile,
                  keyboardType: TextInputType.phone,
                  label: "Mobile Number*",
                  prefixText: "+973 ",
                  validator: (value) => controller.validatemobilenumber(value),
                ),

                const SizedBox(height: 15),

                // AppTextField(
                //   controller: controller.password,

                //   label: "Password*",
                //   validator: (value) => controller.validatepassword(value),
                // ),

                const SizedBox(height: 15),

                AppTextField(
                  controller: controller.email,
                  keyboardType: TextInputType.emailAddress,
                  label: "Email Address*",
                  validator: (value) => controller.validateemail(value),
                ),
                const SizedBox(height: 15),
                AppDropdown(
                  label: "Gender*",
                  items: const ["Male", "Female", "Other"],
                  value: controller.gender,
                  onChanged: (val) => setState(() => controller.gender = val),
                  validator: (val) => val == null ? "Select gender" : null,
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 47,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isAddress = !_isAddress;
                      });
                    },
                    child: Text(
                      _isAddress ? "Hide Address" : "Add Address",
                      style: TextStyle(color: AppColors.btn_primery),
                    ),
                  ),
                ),

                if (_isAddress)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Address(
                        accountType: "Family",
                        family: true,
                        formKey: _addressFormKey,
                        controller: addressController, //  pass controller
                      ),
                    ],
                  ),

                const SizedBox(height: 10),
              ],
            ),
          ),

        
          if (!_hideBottomButton)
            AppButton(
              text: _currentMemberIndex < _totalMembers
                  ? "Add Member"
                  : "Finish",
              isLoading: _isLoading,
              onPressed: _addMember,
              color: AppColors.btn_primery,
              width: double.infinity,
              height: 47,
            ),
            const SizedBox(height: 10,)
        ],
      ),
    );
  }
}
