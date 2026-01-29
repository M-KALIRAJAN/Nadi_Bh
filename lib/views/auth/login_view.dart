// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:nadi_user_app/controllers/login_controller.dart';
// import 'package:nadi_user_app/core/constants/app_consts.dart';
// import 'package:nadi_user_app/core/utils/logger.dart';
// import 'package:nadi_user_app/preferences/preferences.dart';
// import 'package:nadi_user_app/routing/app_router.dart';
// import 'package:nadi_user_app/services/auth_service.dart';
// import 'package:nadi_user_app/widgets/app_back.dart';
// import 'package:nadi_user_app/widgets/buttons/primary_button.dart';
// import 'package:nadi_user_app/widgets/inputs/app_text_field.dart';

// class LoginView extends StatefulWidget {
//   const LoginView({super.key});

//   @override
//   State<LoginView> createState() => _LoginViewState();
// }

// class _LoginViewState extends State<LoginView> {
//   final controller = LoginController();
//   String? emailError;
//   String? passwordError;

//   bool _obscure = true;

//   final AuthService _authService = AuthService();
//   bool isChecked = false;
//   Future<void> Login(BuildContext context) async {
//     // clear old errors
//     setState(() {
//       emailError = null;
//       passwordError = null;
//     });

//     final loginData = controller.getLoginData();

//     try {
//       final response = await _authService.LoginApi(
//         email: loginData.email,
//         password: loginData.password,
//       );

//       if (response != null && response['token'] != null) {
//         await AppPreferences.saveToken(response['token']);
//         await AppPreferences.saveAccountType(response['accountType']);
//         await AppPreferences.setLoggedIn(true);

//         context.push(RouteNames.bottomnav);
//       }
//     } on DioException catch (e) {
//       if (e.response != null && e.response?.data != null) {
//         final message = e.response?.data['message'];

//         setState(() {
//           // decide where to show error
//           if (message.toString().toLowerCase().contains('email')) {
//             emailError = message;
//           } else if (message.toString().toLowerCase().contains('password')) {
//             passwordError = message;
//           } else {
//             passwordError = "Invalid email or password";
//           }
//         });
//       }
//     } catch (e) {
//       setState(() {
//         passwordError = "Something went wrong";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
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
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               return SingleChildScrollView(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(
//                     minHeight: constraints.maxHeight, // <-- full height!
//                   ),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 65),

//                       Center(
//                         child: Image.asset(
//                           "assets/icons/logo.png",
//                           height: 146,
//                           width: 152,
//                         ),
//                       ),

//                       const SizedBox(height: 40),

//                       Expanded(
//                         child: Container(
//                           width: double.infinity,
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(30),
//                               topRight: Radius.circular(30),
//                             ),
//                           ),
//                           padding: const EdgeInsets.all(20),

//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const SizedBox(height: 20),

//                               const Text(
//                                 "Welcome!",
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),

//                               const SizedBox(height: 25),

//                               TextFormField(
//                                 controller: controller.email,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: InputDecoration(
//                                   labelText: "Email Address",
//                                   errorText:
//                                       emailError, // API error shows here
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     // borderSide: const BorderSide(color: Colors.green, width: 2),
//                                   ),
//                                 ),
//                               ),

//                               const SizedBox(height: 15),
//                               const SizedBox(height: 10),
//                               TextFormField(
//                                 controller: controller.password,
//                                 obscureText: _obscure,
//                                 decoration: InputDecoration(
//                                   labelText: "Password",
//                                   errorText: passwordError, //  API error here
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     // borderSide: const BorderSide(color: Colors.green, width: 2),
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _obscure
//                                           ? Icons.visibility_off
//                                           : Icons.visibility,
//                                     ),
//                                     onPressed: () {
//                                       setState(() {
//                                         _obscure = !_obscure;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                               ),

//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Checkbox(
//                                         value: isChecked,
//                                         checkColor: Colors.white,
//                                         activeColor: AppColors.btn_primery,
//                                         onChanged: (v) {
//                                           setState(() => isChecked = v!);
//                                         },
//                                       ),
//                                       const Text("Remember me"),
//                                     ],
//                                   ),
//                                   TextButton(
//                                     onPressed: () =>
//                                         context.push(RouteNames.uploadcard),
//                                     child: const Text(
//                                       "Forgot Password?",
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: AppColors.btn_primery,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),

//                               SizedBox(height: 20),

//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: AppButton(
//                                       text: "Sign Up",
//                                       color: AppColors.button_secondary,
//                                       width: double.infinity,
//                                       onPressed: () =>
//                                           context.push(RouteNames.Account),
//                                       height: 50,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   Expanded(
//                                     child: AppButton(
//                                       text: "Sign In",
//                                       color: const Color(0xFF0D5F48),
//                                       width: double.infinity,
//                                       onPressed: () {
//                                         Login(context);
//                                       },
//                                       height: 50,
//                                     ),
//                                   ),
//                                 ],
//                               ),

//                               const SizedBox(height: 20),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/controllers/login_controller.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
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
  // final NotificationService _notificationService = NotificationService();

  bool isChecked = false;
  bool _obscure = true;

  String? emailError;
  String? passwordError;
  @override
  void initState() {
    super.initState();
    // START LISTENING FOR PUSH
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   NotificationService.initialize(context);
    // });
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
  print(" fcmToken******************: $fcmToken");
    try {
      final response = await _authService.LoginApi(
        email: loginData.email,
        password: loginData.password,
        fcmToken:fcmToken
      );
     debugPrint("loginData: ${response?['data']}");
      if (response != null && response['token'] != null) {
        await AppPreferences.saveToken(response['token']);
        await AppPreferences.setLoggedIn(true);
        await AppPreferences.saveUserId(response['userId']);
        await AppPreferences.saveAccountType(response['accountType']);
        //  REMEMBER ME LOGIC
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
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // BACKGROUND IMAGE
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/back.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                SizedBox(height: height * 0.07),
                /// LOGO
                Image.asset("assets/icons/logo.png", height: 170),
                SizedBox(height: height * 0.10),
                /// FORM
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        20,
                        20,
                        MediaQuery.of(context).viewInsets.bottom + 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome!",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            controller: controller.email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email Address",
                              floatingLabelStyle: TextStyle(color: AppColors.btn_primery),
                              errorText: emailError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),

                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.btn_primery,
                                  width: 1.5
                                )
                              )
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: controller.password,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              labelText: "Password",
                              floatingLabelStyle: const TextStyle(color: AppColors.btn_primery),
                              errorText: passwordError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                                 focusedBorder: OutlineInputBorder(
                                borderRadius:  BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.btn_primery,
                                  width: 1.5
                                )),
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
                            runSpacing: 5,
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
                                  const Text("Remember me"),
                                ],
                              ),
                              TextButton(
                                onPressed: () =>
                                    context.push(RouteNames.forgotpassword),
                                child: const Text(
                                  "Forgot Password?",
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
                                  text: "Sign Up",
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
                                  text: "Sign In",
                                  width: 59,
                                  color: const Color(0xFF0D5F48),
                                  height: 50,
                                  onPressed: () => login(context),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          const Center(child: Text("OR")),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              context.push(RouteNames.phonewithotp);
                            },
                            child: Center(
                              child: Text(
                                "Sign In with OTP",
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
        ],
      ),
    );
  }
}
