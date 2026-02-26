// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:nadi_user_app/core/utils/logger.dart';
// import 'package:video_player/video_player.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:nadi_user_app/core/network/dio_client.dart';
// import 'package:nadi_user_app/preferences/preferences.dart';
// import 'package:nadi_user_app/routing/app_router.dart';
// import 'package:nadi_user_app/services/onbording_service.dart';

// class CustomSplashScreen extends StatefulWidget {
//   const CustomSplashScreen({super.key});

//   @override
//   State<CustomSplashScreen> createState() => _CustomSplashScreenState();
// }

// class _CustomSplashScreenState extends State<CustomSplashScreen>
//     with SingleTickerProviderStateMixin {
//   final OnbordingService _onbordingService = OnbordingService();

//   String? imageUrl;
//   String? videoUrl;
//   VideoPlayerController? _videoController;

//   bool isLoading = true;

//   // 🔹 Animation
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     AppLogger.success("🚀 Splash initState()");

//     // 🔹 Zoom / flash animation
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);

//     _scaleAnimation = Tween<double>(begin: 0.95, end: 2.05).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _initNotifications();
//     _loadSplashMedia();
//   }

//   // LOAD IMAGE / VIDEO FROM BACKEND

//   Future<void> _loadSplashMedia() async {

//     try {
//       final response = await _onbordingService.loading();
//       AppLogger.success("✅ API Response: ${jsonEncode(response)}");

//       if (response == null ||
//           response['data'] == null ||
//           response['data'].isEmpty) {
//         _startNavigation();
//         return;
//       }

//       final item = response['data'][0];
//       final image = item['image'];
//       final video = item['video'];

//       // VIDEO
//       if (video != null && video.toString().isNotEmpty) {
//         videoUrl = "${ImageBaseUrl.baseUrl}/$video";

//         _videoController = VideoPlayerController.networkUrl(
//           Uri.parse(videoUrl!),
//         );

//         await _videoController!.initialize();
//         _videoController!
//           ..setLooping(true)
//           ..play();
//       }
//       // IMAGE
//       else if (image != null && image.toString().isNotEmpty) {
//         imageUrl = "${ImageBaseUrl.baseUrl}/$image";
//       }

//       setState(() => isLoading = false);
//       _startNavigation();
//     } catch (e) {
//       AppLogger.error("❌ Splash error: $e");
//       _startNavigation();
//     }
//   }

//   // FIREBASE NOTIFICATIONS

//   Future<void> _initNotifications() async {
//     await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     final token = await FirebaseMessaging.instance.getToken();
//     if (token != null) {
//       await AppPreferences.savefcmToken(token);
//     }
//   }

//   // NAVIGATION

//   void _startNavigation() {
//     Future.delayed(const Duration(seconds: 5), () {
//       if (!mounted) return;
//       _decideNavigation();
//     });
//   }

//   Future<void> _decideNavigation() async {
//     final isLoggedIn = await AppPreferences.isLoggedIn();
//     final hasSeenAbout = await AppPreferences.hasSeenAbout();
//     final token = await AppPreferences.getToken();

//     if (!mounted) return;

//     if (!hasSeenAbout) {
//       context.go(RouteNames.language);
//     } else if (isLoggedIn && token.isNotEmpty) {
//       context.go(RouteNames.bottomnav);
//     } else {
//       context.go(RouteNames.login);
//     }
//   }

//   // MEDIA UI WITH ANIMATION

//   Widget _buildMedia() {
//     Widget child;

//     if (_videoController != null && _videoController!.value.isInitialized) {
//       child = AspectRatio(
//         aspectRatio: _videoController!.value.aspectRatio,
//         child: VideoPlayer(_videoController!),
//       );
//     } else if (imageUrl != null) {
//       child = Image.network(
//         imageUrl!,
//         width: 180,
//         height: 180,
//         fit: BoxFit.contain,
//       );
//     } else {
//       child = Image.asset('assets/icons/logo.png', width: 150, height: 150);
//     }

//     // 🔹 Zoom / flash animation wrapper
//     return ScaleTransition(scale: _scaleAnimation, child: child);
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _videoController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D5F48),
//       body: Center(child: isLoading ? const SizedBox() : _buildMedia()),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/services/onbording_service.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:go_router/go_router.dart';

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

  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    AppLogger.success("🚀 Splash initState()");

    _setupAnimation();
    _initNotifications();
    _loadSplashMedia();
  }

  // ================= ANIMATION SETUP =================
  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    // ✅ Smooth rotation (2–3 turns)
    _rotationAnimation =
        Tween<double>(
          begin: 0,
          end: 3, // 3 full rotations
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    // ✅ Navigate when animation completes
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _decideNavigation();
      }
    });

    _animationController.forward();
  }

  // ================= LOAD MEDIA =================
  Future<void> _loadSplashMedia() async {
    try {
      final response = await _onbordingService.loading();

      AppLogger.success("✅ API Response: ${jsonEncode(response)}");

      if (response == null ||
          response['data'] == null ||
          response['data'].isEmpty) {
        setState(() => isLoading = false);
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
    } catch (e) {
      AppLogger.error("❌ Splash error: $e");
      setState(() => isLoading = false);
    }
  }

  // ================= FCM =================
  Future<void> _initNotifications() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true);

    AppLogger.success("Permission: ${settings.authorizationStatus}");

    // Token refresh listener
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      AppLogger.success("FCM Token refreshed: $token");
      await AppPreferences.savefcmToken(token);
    });

    /// ✅ SAFE TOKEN GET (important for iOS simulator)
    try {
      final token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        AppLogger.success("FCM Token: $token");
        await AppPreferences.savefcmToken(token);
      } else {
        AppLogger.error("FCM token is null (maybe simulator)");
      }
    } catch (e) {
      AppLogger.error("FCM not available (Simulator): $e");
    }
  }

  // ================= NAVIGATION =================
  Future<void> _decideNavigation() async {
    final isLoggedIn = await AppPreferences.isLoggedIn();
    final hasSeenAbout = await AppPreferences.hasSeenAbout();
    final token = await AppPreferences.getToken();

    if (!mounted) return;

    if (!hasSeenAbout) {
      context.go(RouteNames.language);
    } else if (isLoggedIn && token.isNotEmpty) {
      //      final userId = await AppPreferences.getUserId();
      // if(userId != null){
      //       await StreamChatService().connectUser(userId);
      // }
      context.go(RouteNames.bottomnav);
    } else {
      context.go(RouteNames.login);
    }
  }

  // ================= UI =================
  Widget _buildMedia() {
    // 🎥 VIDEO → NO ANIMATION
    if (_videoController != null && _videoController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    }

    // 🖼 IMAGE / LOGO → ONLY ROTATION (NO ZOOM)
    Widget imageWidget;

    if (imageUrl != null) {
      imageWidget = Image.network(
        imageUrl!,
        width: 180,
        height: 180,
        fit: BoxFit.contain,
      );
    } else {
      imageWidget = Image.asset(
        'assets/icons/logo.png',
        width: 170,
        height: 170,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RotationTransition(
          turns: _rotationAnimation, 
          child: imageWidget,
        ),

        const SizedBox(height: 45),
        SizedBox(
          width: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              minHeight: 5,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      ],
    );
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF6473B7),
              const Color(0xFF6473B7).withValues(alpha: 0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : _buildMedia(),
        ),
      ),
    );
  }
}
