// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:nadi_user_app/core/constants/app_consts.dart';
// import 'package:nadi_user_app/core/utils/logger.dart';
// import 'package:nadi_user_app/core/utils/snackbar_helper.dart';
// import 'package:nadi_user_app/preferences/preferences.dart';
// import 'package:nadi_user_app/routing/app_router.dart';
// import 'package:nadi_user_app/services/auth_service.dart';
// import 'package:nadi_user_app/widgets/buttons/primary_button.dart';
// import 'package:nadi_user_app/widgets/inputs/app_text_field.dart';
// import 'package:pinput/pinput.dart';

// class SignInOtp extends StatefulWidget {
//   const SignInOtp({super.key});

//   @override
//   State<SignInOtp> createState() => _SignInOtpState();
// }

// class _SignInOtpState extends State<SignInOtp> {
//   final _formKey = GlobalKey<FormState>();
//   final _phoneController = TextEditingController();
//   final _otpController = TextEditingController();
//   final AuthService _authService = AuthService();
//   bool _showOtp = false;
//   bool _isOtpError = false;

//   final defaultPinTheme = PinTheme(
//     width: 50,
//     height: 50,
//     textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(color: AppColors.btn_primery),
//     ),
//   );

//   final errorPinTheme = PinTheme(
//     width: 50,
//     height: 50,
//     textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(color: Colors.red),
//     ),
//   );

//   Future<void> sendOtp() async {
//     try {
//       final mobileNumber = _phoneController.text;
//       final response = await _authService.OTPwithphone(
//         mobileNumber: mobileNumber,
//       );
//       AppLogger.warn("phone with otp $response");
//       setState(() => _showOtp = true);
//       if (response != null) {
//         setState(() => _showOtp = true);
//         final otp = response['otp'].toString();

//         ///  SHOW SNACKBAR
//         SnackbarHelper.ShowSuccess(context, otp);

//         Future.delayed(const Duration(seconds: 1), () {});
//       }
//     } catch (e) {
//       AppLogger.error("Send otp with phone $e");
//     }
//   }

//   Future<void> OTPphoneverify()async{
//     final otp = _otpController.text.trim();
//     final mobileNumber = _phoneController.text;
//       try{
//     final response = await _authService.OTPphoneverify(
//       otp: otp,
//        mobileNumber: mobileNumber
//        );
//        AppLogger.warn("OTPphoneverify $response");
//        if(response != null){
//            await AppPreferences.saveToken(response['token']);
//            await AppPreferences.saveAccountType(response['accountType']);
//            await AppPreferences.saveUserId(response['userId']);
//             context.go(RouteNames.bottomnav);
//        }

//       }catch(e){
//         AppLogger.error("OTPphoneverify $e");
//       }
//   }

//   @override
//   Widget build(BuildContext context) {
//      final size = MediaQuery.of(context).size;
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/images/back.png"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                         SizedBox(height: size.height * 0.03),

//                         /// LOGO (Responsive)
//                         Image.asset(
//                           "assets/images/logo.png",
//                           height: size.height * 0.5,
//                         ),
//                           SizedBox(height: size.height * 0.03),
//                 Expanded(
//                   child: Container(
//                     width: double.infinity,
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         topRight: Radius.circular(30),
//                       ),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 17,
//                       vertical: 17,
//                     ),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 20),
//                           const Text(
//                             "Sign In with OTP",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20,
//                             ),
//                           ),
//                           const SizedBox(height: 20),

//                           // PHONE INPUT
//                           AppTextField(
//                             label: "Enter Phone Number",
//                             keyboardType: TextInputType.phone,
//                             controller: _phoneController,
//                             prefixText: "+973 ",
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "Please enter phone number";
//                               } else if (value.length != 8 ||
//                                   !RegExp(r'^[0-9]+$').hasMatch(value)) {
//                                 return "Phone number must be 8 digits";
//                               }
//                               return null;
//                             },
//                           ),

//                           const SizedBox(height: 20),
//                           if (!_showOtp) ...[
//                             AppButton(
//                               height: 48,
//                               width: double.infinity,
//                               color: AppColors.btn_primery,
//                               text: "Send OTP",
//                               onPressed: () async {
//                                 if (_formKey.currentState!.validate()) {
//                                   await sendOtp();
//                                 }
//                               },
//                             ),
//                           ],

//                           // OTP INPUT
//                           if (_showOtp) ...[
//                             const Text(
//                               "Enter OTP",
//                               style: TextStyle(fontSize: 18),
//                             ),
//                             const SizedBox(height: 15),
//                             Center(
//                               child: Pinput(
//                                 controller: _otpController,
//                                 length: 4,
//                                 defaultPinTheme: defaultPinTheme,
//                                 focusedPinTheme: defaultPinTheme.copyWith(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(12),
//                                     border: Border.all(color: Colors.green),
//                                   ),
//                                 ),
//                                 submittedPinTheme: defaultPinTheme.copyWith(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(12),
//                                     border: Border.all(color: Colors.blue),
//                                   ),
//                                 ),
//                                 errorPinTheme: errorPinTheme,
//                                 forceErrorState: _isOtpError,
//                                 keyboardType: TextInputType.number,
//                                 onChanged: (value) {
//                                   if (_isOtpError)
//                                     setState(() => _isOtpError = false);
//                                 },
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             AppButton(
//                               height: 48,
//                               width: double.infinity,
//                               color: AppColors.btn_primery,
//                               text: "Sign In",
//                               onPressed: () async {
//                                 if (_otpController.text.length == 4) {
//                                   await OTPphoneverify();
//                                 } else {
//                                   setState(() => _isOtpError = true);
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text("Enter valid OTP"),
//                                     ),
//                                   );
//                                 }
//                               },
//                             ),
//                           ],

//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/core/utils/snackbar_helper.dart';
import 'package:nadi_user_app/l10n/app_localizations.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/services/auth_service.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';
import 'package:nadi_user_app/widgets/inputs/app_text_field.dart';
import 'package:pinput/pinput.dart';

class SignInOtp extends StatefulWidget {
  const SignInOtp({super.key});

  @override
  State<SignInOtp> createState() => _SignInOtpState();
}

class _SignInOtpState extends State<SignInOtp> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _showOtp = false;
  bool _isOtpError = false;

  Future<void> sendOtp() async {
    try {
      final mobileNumber = _phoneController.text;
      final fcmToken = await AppPreferences.getfcmToken();
      final response = await _authService.OTPwithphone(
        mobileNumber: mobileNumber,
        fcmToken: fcmToken,
      );
      AppLogger.warn("phone with otp $response");

      if (response != null) {
        setState(() => _showOtp = true);
        final otp = response['otp'].toString();
        SnackbarHelper.ShowSuccess(context, otp);
      }
    } catch (e) {
      AppLogger.error("Send otp with phone $e");
    }
  }

  Future<void> OTPphoneverify() async {
    final otp = _otpController.text.trim();
    final mobileNumber = _phoneController.text;
    try {
      final response = await _authService.OTPphoneverify(
        otp: otp,
        mobileNumber: mobileNumber,
      );
      AppLogger.warn("OTPphoneverify $response");
      if (response != null) {
        await AppPreferences.saveToken(response['token']);
        await AppPreferences.saveAccountType(response['accountType']);
        await AppPreferences.saveUserId(response['userId']);
        context.go(RouteNames.bottomnav);
      }
    } catch (e) {
      AppLogger.error("OTPphoneverify $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.btn_primery),
      ),
    );

    final errorPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red),
      ),
    );
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.03),

                        /// LOGO
                        Image.asset(
                          "assets/images/logo.png",
                          height: size.height * 0.35,
                        ),

                        SizedBox(height: size.height * 0.08),

                        /// White form container that fills remaining space
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 17,
                              vertical: 20,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(
                                     l10n.signInWithOtp,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  /// Phone Input
                                  AppTextField(
                                     label: l10n.enterPhoneNumber,
                                    keyboardType: TextInputType.phone,
                                    controller: _phoneController,
                                    prefixText: "+973 ",
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                          return l10n.pleaseEnterPhoneNumber;
                                      } else if (value.length != 8 ||
                                          !RegExp(
                                            r'^[0-9]+$',
                                          ).hasMatch(value)) {
                                       return l10n.phoneMustBe8Digits;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  /// Send OTP Button
                                  if (!_showOtp)
                                    AppButton(
                                      height: 48,
                                      width: double.infinity,
                                      color: AppColors.btn_primery,
                                      text: l10n.resendOtp,
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          await sendOtp();
                                        }
                                      },
                                    ),

                                  /// OTP Input
                                  if (_showOtp) ...[
                                    const SizedBox(height: 20),
                                     Text(
                                      l10n.enterOtp,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(height: 15),
                                    Center(
                                      child: Pinput(
                                        controller: _otpController,
                                        length: 4,

                                        defaultPinTheme: defaultPinTheme,
                                        focusedPinTheme: defaultPinTheme
                                            .copyWith(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                        submittedPinTheme: defaultPinTheme
                                            .copyWith(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                        errorPinTheme: errorPinTheme,
                                        forceErrorState: _isOtpError,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          if (_isOtpError)
                                            setState(() => _isOtpError = false);
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    AppButton(
                                      height: 48,
                                      width: double.infinity,
                                      color: AppColors.btn_primery,
                                      text: l10n.signIn,
                                      onPressed: () async {
                                        if (_otpController.text.length == 4) {
                                          await OTPphoneverify();
                                        } else {
                                          setState(() => _isOtpError = true);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                             SnackBar(
                                               content: Text(l10n.enterValidOtp),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
