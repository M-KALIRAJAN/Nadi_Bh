// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:video_player/video_player.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:nadi_user_app/core/network/dio_client.dart';
// import 'package:nadi_user_app/core/utils/logger.dart';
// import 'package:nadi_user_app/preferences/preferences.dart';
// import 'package:nadi_user_app/routing/app_router.dart';
// import 'package:nadi_user_app/services/onbording_service.dart';

// class CustomSplashScreen extends StatefulWidget {
//   const CustomSplashScreen({super.key});

//   @override
//   State<CustomSplashScreen> createState() => _CustomSplashScreenState();
// }

// class _CustomSplashScreenState extends State<CustomSplashScreen> {
//   final OnbordingService _onbordingService = OnbordingService();

//   String? imageUrl;
//   String? videoUrl;
//   VideoPlayerController? _videoController;

//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     debugPrint("🚀 Splash initState()");
//     _initNotifications();
//     _loadSplashMedia();

//   }

//   // LOAD IMAGE / VIDEO FROM BACKEND

//   Future<void> _loadSplashMedia() async {
//     debugPrint("📡 Calling splash API...");

//     try {
//       final response = await _onbordingService.loading();
//       debugPrint("✅ API Response: ${jsonEncode(response)}");

//       if (response == null ||
//           response['data'] == null ||
//           response['data'].isEmpty) {
//         debugPrint("⚠️ No splash data found");
//         _startNavigation();
//         return;
//       }

//       final item = response['data'][0];
//       final image = item['image'];
//       final video = item['video'];

//       debugPrint("🖼 IMAGE VALUE => $image");
//       debugPrint("🎬 VIDEO VALUE => $video");

//       // VIDEO
//       if (video != null && video.toString().isNotEmpty) {
//         videoUrl = "${ImageBaseUrl.baseUrl}/$video";
//         debugPrint("🎥 VIDEO URL => $videoUrl");

//         _videoController = VideoPlayerController.networkUrl(
//           Uri.parse(videoUrl!),
//         );

//         await _videoController!.initialize();
//         _videoController!
//           ..setLooping(true)
//           ..play();

//         debugPrint("▶️ Video initialized & playing");
//       }
//       // IMAGE
//       else if (image != null && image.toString().isNotEmpty) {
//         imageUrl = "${ImageBaseUrl.baseUrl}/$image";
//         debugPrint("🖼 Image URL => $imageUrl");
//       }

//       setState(() => isLoading = false);
//       _startNavigation();
//     } catch (e, s) {
//       debugPrint("❌ Splash load error: $e");
//       debugPrint("STACK: $s");
//       _startNavigation();
//     }
//   }

//   // FIREBASE NOTIFICATIONS

//   Future<void> _initNotifications() async {
//     debugPrint("🔔 Requesting FCM permission");

//     await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     final token = await FirebaseMessaging.instance.getToken();
//     debugPrint("🔥 FCM TOKEN => $token");

//     if (token != null) {
//       await AppPreferences.savefcmToken(token);
//     }
//   }

//   void _startNavigation() {
//     debugPrint("⏱ Starting navigation timer (5 sec)");

//     Future.delayed(const Duration(seconds: 5), () {
//       if (!mounted) return;
//       _decideNavigation();
//     });
//   }

//   Future<void> _decideNavigation() async {
//     debugPrint("🧭 Deciding navigation");

//     final isLoggedIn = await AppPreferences.isLoggedIn();
//     final hasSeenAbout = await AppPreferences.hasSeenAbout();

//     debugPrint("🔐 isLoggedIn => $isLoggedIn");
//     debugPrint("📘 hasSeenAbout => $hasSeenAbout");

//     if (!mounted) return;

//     final String token = await AppPreferences.getToken();

//     if (isLoggedIn && token.isNotEmpty) {
//       context.go(RouteNames.bottomnav);
//     } else {
//       context.go(RouteNames.login);
//     }

//     if (!hasSeenAbout) {
//       debugPrint("➡️ Navigate: Language");
//       context.go(RouteNames.language);
//     }
//     // else if (isLoggedIn) {
//     //   debugPrint("➡️ Navigate: BottomNav");
//     //   context.go(RouteNames.bottomnav);
//     // } else {
//     //   debugPrint("➡️ Navigate: Login");
//     //   context.go(RouteNames.login);
//     // }
//   }

//   Widget _buildMedia() {
//     if (_videoController != null && _videoController!.value.isInitialized) {
//       debugPrint("🎬 Rendering Video");
//       return AspectRatio(
//         aspectRatio: _videoController!.value.aspectRatio,
//         child: VideoPlayer(_videoController!),
//       );
//     }

//     if (imageUrl != null) {
//       debugPrint("🖼 Rendering Image");
//       return Image.network(
//         imageUrl!,
//         width: 180,
//         height: 180,
//         fit: BoxFit.contain,
//       );
//     }

//     debugPrint("📦 Rendering Default Image");
//     return Image.asset('assets/icons/logo.png', width: 150, height: 150);
//   }

//   @override
//   void dispose() {
//     debugPrint("🧹 Disposing splash");
//     _videoController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D5F48),
//       body: Center(
//         child: isLoading
//             ? Text("data")
//             //          Image.asset(
//             //   'assets/icons/logo.png',
//             //   width: 150,
//             //   height: 150,
//             // )
//             : _buildMedia(),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/services/onbording_service.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({super.key});

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen>
    with SingleTickerProviderStateMixin {
  final OnbordingService _onbordingService = OnbordingService();

  String? imageUrl;
  String? videoUrl;
  VideoPlayerController? _videoController;

  bool isLoading = true;

  // 🔹 Animation
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;


  @override
  void initState() {
    super.initState();
    AppLogger.success("🚀 Splash initState()");

    // 🔹 Zoom / flash animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 2.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _initNotifications();
    _loadSplashMedia();
  }


  // LOAD IMAGE / VIDEO FROM BACKEND

  Future<void> _loadSplashMedia() async {
   

    try {
      final response = await _onbordingService.loading();
      AppLogger.success("✅ API Response: ${jsonEncode(response)}");

      if (response == null ||
          response['data'] == null ||
          response['data'].isEmpty) {
        _startNavigation();
        return;
      }

      final item = response['data'][0];
      final image = item['image'];
      final video = item['video'];

      // VIDEO
      if (video != null && video.toString().isNotEmpty) {
        videoUrl = "${ImageBaseUrl.baseUrl}/$video";

        _videoController = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl!),
        );

        await _videoController!.initialize();
        _videoController!
          ..setLooping(true)
          ..play();
      }
      // IMAGE
      else if (image != null && image.toString().isNotEmpty) {
        imageUrl = "${ImageBaseUrl.baseUrl}/$image";
      }

      setState(() => isLoading = false);
      _startNavigation();
    } catch (e) {
      AppLogger.error("❌ Splash error: $e");
      _startNavigation();
    }
  }


  // FIREBASE NOTIFICATIONS

  Future<void> _initNotifications() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await AppPreferences.savefcmToken(token);
    }
  }


  // NAVIGATION

  void _startNavigation() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      _decideNavigation();
    });
  }

  Future<void> _decideNavigation() async {
    final isLoggedIn = await AppPreferences.isLoggedIn();
    final hasSeenAbout = await AppPreferences.hasSeenAbout();
    final token = await AppPreferences.getToken();

    if (!mounted) return;

    if (!hasSeenAbout) {
      context.go(RouteNames.language);
    } else if (isLoggedIn && token.isNotEmpty) {
      context.go(RouteNames.bottomnav);
    } else {
      context.go(RouteNames.login);
    }
  }


  // MEDIA UI WITH ANIMATION
 
  Widget _buildMedia() {
    Widget child;

    if (_videoController != null && _videoController!.value.isInitialized) {
      child = AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    } else if (imageUrl != null) {
      child = Image.network(
        imageUrl!,
        width: 180,
        height: 180,
        fit: BoxFit.contain,
      );
    } else {
      child = Image.asset('assets/icons/logo.png', width: 150, height: 150);
    }

    // 🔹 Zoom / flash animation wrapper
    return ScaleTransition(scale: _scaleAnimation, child: child);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D5F48),
      body: Center(child: isLoading ? const SizedBox() : _buildMedia()),
    );
  }
}
