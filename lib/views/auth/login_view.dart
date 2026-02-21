// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:nadi_user_app/controllers/login_controller.dart';
// import 'package:nadi_user_app/core/constants/app_consts.dart';
// import 'package:nadi_user_app/core/utils/logger.dart';
// import 'package:nadi_user_app/preferences/preferences.dart';
// import 'package:nadi_user_app/routing/app_router.dart';
// import 'package:nadi_user_app/services/auth_service.dart';
// import 'package:nadi_user_app/widgets/buttons/primary_button.dart';

// class LoginView extends StatefulWidget {
//   const LoginView({super.key});

//   @override
//   State<LoginView> createState() => _LoginViewState();
// }

// class _LoginViewState extends State<LoginView> {
//   final LoginController controller = LoginController();
//   final AuthService _authService = AuthService();
//   // final NotificationService _notificationService = NotificationService();

//   bool isChecked = false;
//   bool _obscure = true;

//   String? emailError;
//   String? passwordError;
//   @override
//   void initState() {
//     super.initState();
//     // START LISTENING FOR PUSH
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   NotificationService.initialize(context);
//     // });
//     _loadRememberMe();
//   }

//   Future<void> _loadRememberMe() async {
//     final remember = await AppPreferences.isRemeberMe();
//     if (remember) {
//       final email = await AppPreferences.getRememberEmail();
//       if (email != null) {
//         controller.email.text = email;
//       }
//       setState(() {
//         isChecked = true;
//       });
//     }
//   }

//   Future<void> login(BuildContext context) async {
//     setState(() {
//       emailError = null;
//       passwordError = null;
//     });

//     final loginData = controller.getLoginData();
//     final fcmToken = await AppPreferences.getfcmToken();
//     print(" fcmToken******************: $fcmToken");
//     try {
//       final response = await _authService.LoginApi(
//         email: loginData.email,
//         password: loginData.password,
//         fcmToken: fcmToken,
//       );
//       AppLogger.warn("loginData: ${response?['data']}");
//       if (response != null && response['token'] != null) {
//         await AppPreferences.saveToken(response['token']);
//         await AppPreferences.setLoggedIn(true);
//         await AppPreferences.saveUserId(response['userId']);
//         await AppPreferences.saveAccountType(response['accountType']);
//         //  REMEMBER ME LOGIC
//         if (isChecked) {
//           await AppPreferences.setRememberMe(true);
//           await AppPreferences.saveRemeberEmail(loginData.email);
//         } else {
//           await AppPreferences.clearRememberMe();
//         }
//         context.go(RouteNames.bottomnav);
//       }
//     } on DioException catch (e) {
//       final message = e.response?.data?['message'] ?? "Invalid credentials";

//       setState(() {
//         if (message.toString().toLowerCase().contains('email')) {
//           emailError = message;
//         } else {
//           passwordError = message;
//         }
//       });
//     } catch (_) {
//       setState(() {
//         passwordError = "Something went wrong";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Stack(
//         children: [
//           // BACKGROUND IMAGE
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/images/back.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           SafeArea(
//             bottom: false,
//             child: Column(
//               children: [
//                 SizedBox(height: height * 0.07),

//                 /// LOGO
//                 Image.asset("assets/icons/logo.png", height: 170),
//                 SizedBox(height: height * 0.10),

//                 /// FORM
//                 Expanded(
//                   child: Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.surface,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         topRight: Radius.circular(30),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
//                       child: Column(

//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             "Welcome!",
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 25),
//                           TextFormField(
//                             controller: controller.email,
//                             keyboardType: TextInputType.emailAddress,
//                             decoration: InputDecoration(
//                               labelText: "Email Address",
//                               filled: true,
//                               fillColor: Colors.white,
//                               floatingLabelStyle: TextStyle(
//                                 color: AppColors.btn_primery,
//                               ),
//                               errorText: emailError,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide(
//                                   color: AppColors.btn_primery,
//                                   width: 1.5,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 15),
//                           TextFormField(
//                             controller: controller.password,
//                             obscureText: _obscure,
//                             decoration: InputDecoration(
//                               labelText: "Password",
//                               filled: true,
//                               fillColor: Colors.white,
//                               floatingLabelStyle: const TextStyle(
//                                 color: AppColors.btn_primery,
//                               ),
//                               errorText: passwordError,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: const BorderSide(
//                                   color: AppColors.btn_primery,
//                                   width: 1.5,
//                                 ),
//                               ),
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   _obscure
//                                       ? Icons.visibility_off
//                                       : Icons.visibility,
//                                 ),
//                                 onPressed: () {
//                                   setState(() => _obscure = !_obscure);
//                                 },
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 10),

//                           Wrap(
//                             alignment: WrapAlignment.spaceBetween,
//                             runSpacing: 5,
//                             children: [
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Checkbox(
//                                     value: isChecked,
//                                     activeColor: AppColors.btn_primery,
//                                     onChanged: (v) =>
//                                         setState(() => isChecked = v!),
//                                   ),
//                                   const Text("Remember me"),
//                                 ],
//                               ),
//                               TextButton(
//                                 onPressed: () =>
//                                     context.push(RouteNames.forgotpassword),
//                                 child: const Text(
//                                   "Forgot Password?",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: AppColors.btn_primery,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: AppButton(
//                                   text: "Sign Up",
//                                   width: 59,
//                                   color: AppColors.button_secondary,
//                                   height: 50,
//                                   onPressed: () =>
//                                       context.push(RouteNames.Account),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: AppButton(
//                                   text: "Sign In",
//                                   width: 59,
//                                   color: const Color(0xFF0D5F48),
//                                   height: 50,
//                                   onPressed: () => login(context),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           const SizedBox(height: 10),
//                           const Center(child: Text("OR")),
//                           const SizedBox(height: 10),
//                           InkWell(
//                             onTap: () {
//                               context.push(RouteNames.phonewithotp);
//                             },
//                             child: Center(
//                               child: Text(
//                                 "Sign In with OTP",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.btn_primery,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/controllers/login_controller.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/l10n/app_localizations.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/services/auth_service.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController controller = LoginController();
  final AuthService _authService = AuthService();

  bool isChecked = false;
  bool _obscure = true;

  String? emailError;
  String? passwordError;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final remember = await AppPreferences.isRemeberMe();
    if (remember) {
      final email = await AppPreferences.getRememberEmail();
      if (email != null) {
        controller.email.text = email;
      }
      setState(() {
        isChecked = true;
      });
    }
  }

  Future<void> login(BuildContext context) async {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    final loginData = controller.getLoginData();
    final fcmToken = await AppPreferences.getfcmToken();
      AppLogger.info("Login Fcm Token ******************* $fcmToken");
    try {
      final response = await _authService.LoginApi(
        email: loginData.email,
        password: loginData.password,
        fcmToken: fcmToken,
      );

      AppLogger.warn("loginData: ${response?['data']}");

      if (response != null && response['token'] != null) {
        await AppPreferences.saveToken(response['token']);
        await AppPreferences.setLoggedIn(true);
        await AppPreferences.saveUserId(response['userId']);
        await AppPreferences.saveAccountType(response['accountType']);

        if (isChecked) {
          await AppPreferences.setRememberMe(true);
          await AppPreferences.saveRemeberEmail(loginData.email);
        } else {
          await AppPreferences.clearRememberMe();
        }

        context.go(RouteNames.bottomnav);
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "Invalid credentials";

      setState(() {
        if (message.toString().toLowerCase().contains('email')) {
          emailError = message;
        } else {
          passwordError = message;
        }
      });
    } catch (_) {
      setState(() {
        passwordError = "Something went wrong";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ KEYBOARD SCROLL FIX
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/back.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              //  SCROLL ENABLED
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.07),

                      /// LOGO
                      Image.asset("assets/icons/logo.png", height: 190),
                      SizedBox(height: height * 0.10),

                      /// FORM
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text(
                                   AppLocalizations.of(context)!.welcome,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 25),

                                /// EMAIL
                                TextFormField(
                                  controller: controller.email,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!.enterEmail,
                                    filled: true,
                                    fillColor: Colors.white,
                                    floatingLabelStyle: const TextStyle(
                                      color: AppColors.btn_primery,
                                    ),
                                    errorText: emailError,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: AppColors.btn_primery,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 15),

                                /// PASSWORD
                                TextFormField(
                                  controller: controller.password,
                                  obscureText: _obscure,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!.password,
                                    filled: true,
                                    fillColor: Colors.white,
                                    errorText: passwordError,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: AppColors.btn_primery,
                                        width: 1.5,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscure
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() => _obscure = !_obscure);
                                      },
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          value: isChecked,
                                          activeColor: AppColors.btn_primery,
                                          onChanged: (v) =>
                                              setState(() => isChecked = v!),
                                        ),
                                         Text(AppLocalizations.of(context)!.rememberMe),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () => context.push(
                                        RouteNames.forgotpassword,
                                      ),
                                      child:  Text(
                                        AppLocalizations.of(context)!.forgotPassword,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.btn_primery,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                Row(
                                  children: [
                                    Expanded(
                                      child: AppButton(
                                        text:   AppLocalizations.of(context)!.signUp,
                                        width: 59,
                                        color: AppColors.button_secondary,
                                        height: 50,
                                        onPressed: () =>
                                            context.push(RouteNames.Account),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: AppButton(
                                        text: AppLocalizations.of(context)!.signIn,
                                        width: 59,
                                        color: const Color(0xFF0D5F48),
                                        height: 50,
                                        onPressed: () => login(context),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),
                                 Center(child: Text(AppLocalizations.of(context)!.or)),
                                const SizedBox(height: 10),

                                InkWell(
                                  onTap: () {
                                    context.push(RouteNames.phonewithotp);
                                  },
                                  child:  Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.signInWithOtp,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.btn_primery,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
