import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/views/auth/forgotpassword.dart';
import 'package:nadi_user_app/views/auth/sign_in_otp.dart';
import 'package:nadi_user_app/views/screens/AboutView.dart';
import 'package:nadi_user_app/views/screens/Admin_QuestionerView.dart';
import 'package:nadi_user_app/views/screens/HelpSupportView.dart';
import 'package:nadi_user_app/views/screens/PrivacyPolicyView.dart';
import 'package:nadi_user_app/views/screens/allPointHistory.dart';
import 'package:nadi_user_app/views/screens/edit_profile.dart';
import 'package:nadi_user_app/views/screens/nodifications.dart';
import 'package:nadi_user_app/views/screens/point_details.dart';
import 'package:nadi_user_app/views/screens/points_nodification.dart';
import 'package:nadi_user_app/views/screens/request_People_Details.dart';
import 'package:nadi_user_app/views/screens/send_service_request.dart';
import 'package:nadi_user_app/views/screens/service_request_details.dart';
import 'package:nadi_user_app/views/screens/view_all_logs.dart';
import 'package:nadi_user_app/widgets/dialogs/AccountCreated.dart';
import 'package:nadi_user_app/views/auth/AccountStepper.dart';
import 'package:nadi_user_app/views/auth/account_details.dart';
import 'package:nadi_user_app/views/auth/account_verification.dart';
import 'package:nadi_user_app/views/auth/login_view.dart';
import 'package:nadi_user_app/views/auth/otp.dart';
import 'package:nadi_user_app/views/auth/termsandconditions.dart';
import 'package:nadi_user_app/views/auth/upload_id_view.dart';
import 'package:nadi_user_app/views/bottomnav.dart';
import 'package:nadi_user_app/views/onboarding/about_view.dart';
import 'package:nadi_user_app/views/onboarding/languange_view.dart';
import 'package:nadi_user_app/views/onboarding/welcome_view.dart';
import 'package:nadi_user_app/views/screens/AllService.dart';
import 'package:nadi_user_app/views/screens/CustomSplashScreen.dart';
import 'package:nadi_user_app/views/screens/ServiceRequest.dart';
import 'package:nadi_user_app/views/screens/create_service_request.dart';
import 'package:nadi_user_app/widgets/dialogs/RequestCreateSucess.dart';

final appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const CustomSplashScreen(),
    ),
    GoRoute(
      path: RouteNames.phonewithotp,
      builder: (context, state) => const SignInOtp(),
    ),
    GoRoute(
      path: RouteNames.language,
      builder: (context, state) => const LanguangeView(),
    ),
    GoRoute(
      path: RouteNames.forgotpassword,
      builder: (context, state) => const Forgotpassword(),
    ),
    GoRoute(
      path: RouteNames.requestcreatesucess,
      builder: (context, state) {
        // Cast state.extra to String safely
        final serviceRequestId = state.extra as String?;
        if (serviceRequestId == null) {
          return Scaffold(
            body: Center(child: Text("No Service Request ID found")),
          );
        }
        return Requestcreatesucess(serviceRequestId: serviceRequestId);
      },
    ),

    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: RouteNames.Account,
      builder: (context, state) => const AccountDetails(),
    ),
    GoRoute(
      path: RouteNames.about,
      builder: (context, state) => const AboutView(),
    ),
    GoRoute(
      path: RouteNames.allservice,
      builder: (context, state) => const Allservice(),
    ),
    GoRoute(
      path: RouteNames.nodifications,
      builder: (context, state) => const Nodifications(),
    ),
    GoRoute(
      path: RouteNames.pointnodification,
      builder: (context, state) => const PointsNodification(),
    ),
    GoRoute(
      path: RouteNames.aboutscreen,
      builder: (context, state) => const AboutsView(),
    ),
    GoRoute(
      path: RouteNames.helpSupport,
      builder: (context, state) => const HelpSupportView(),
    ),
    GoRoute(
      path: RouteNames.privacyPolicy,
      builder: (context, state) => const PrivacyPolicyView(),
    ),
GoRoute(
  path: RouteNames.allPointHistory,
  builder: (context, state) => const AllPointHistory(),
),
GoRoute(
  path: RouteNames.requestPeopleDetails,
  builder: (context, state) {
    final data = state.extra as Map<String, dynamic>;

    final peopleId = data['peopleId'] as String;
    final fullName = data['fullName'] as String;
    final image = data['image'] as String;

    return RequestPeopleDetails(
      peopleId: peopleId,
      fullName: fullName, 
      image: image,
    );
  },
),

    GoRoute(
      path: RouteNames.accountverfy,
      builder: (context, state) => const AccountVerification(),
    ),
    GoRoute(
      path: RouteNames.creterequest,
      builder: (context, state) => const CreateServiceRequest(),
    ),

    GoRoute(
      path: RouteNames.uploadcard,
      builder: (context, state) => const UploadIdView(),
    ),
    GoRoute(
      path: RouteNames.viewalllogs,
      builder: (context, state) => const ViewAllLogs(),
    ),
    GoRoute(
      path: RouteNames.welcome,
      builder: (context, state) => const WelcomeView(),
    ),
    GoRoute(
      path: RouteNames.serviceRequestDetails,
      builder: (context, state) {
        final serviceData = state.extra as Map<String, dynamic>;
        return ServiceRequestDetails(serviceData: serviceData);
      },
    ),

    GoRoute(
      name: RouteNames.stepper,
      path: RouteNames.stepper,
      builder: (context, state) {
        final accountType = state.extra as String? ?? "Individual";
        return AccountStepper(accountType: accountType);
      },
    ),

    GoRoute(
      path: RouteNames.servicerequestsubmitted,
      builder: (context, state) => const Servicerequest(),
    ),
    GoRoute(
      path: RouteNames.Terms,
      builder: (context, state) => const Termsandconditions(),
    ),
    GoRoute(
      path: RouteNames.accountcreated,
      builder: (context, state) => const Accountcreated(),
    ),
    GoRoute(
      path: RouteNames.opt,
      builder: (context, state) {
        final otp = state.extra as String?;
        return Otp(receivedOtp: otp);
      },
    ),

    GoRoute(
      builder: (context, state) => const EditProfile(),
      path: RouteNames.editprfoile,
    ),
    GoRoute(
      path: RouteNames.pointdetails,
      builder: (context, state) => const PointDetails(),
    ),
    GoRoute(
      path: RouteNames.pointdetails,
      builder: (context, state) => const PointDetails(),
    ),
    GoRoute(
      path: RouteNames.sendservicerequest,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return SendServiceRequest(
          title: data['title'],
          imagePath: data['imagePath'],
          serviceId: data['serviceId'],
          points:data['points'],
        );
      },
    ),
GoRoute(
  path: RouteNames.adminrequestquestion,
  builder: (context, state) => const AdminQuestionerview(),
  ),
    GoRoute(
      path: RouteNames.bottomnav,
      builder: (context, state) => const BottomNav(),
    ),
  ],
);


