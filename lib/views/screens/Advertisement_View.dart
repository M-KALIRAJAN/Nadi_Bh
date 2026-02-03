import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/providers/Advertisement_Provider.dart';
import 'package:video_player/video_player.dart';

class AdvertisementCarousel extends ConsumerStatefulWidget {
  const AdvertisementCarousel({super.key});

  @override
  ConsumerState<AdvertisementCarousel> createState() =>
      _AdvertisementCarouselState();
}

class _AdvertisementCarouselState
    extends ConsumerState<AdvertisementCarousel> {
  VideoPlayerController? _controller;
  bool _videoError = false;
  String? _currentVideoUrl;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _setupVideo(String url) async {
    try {
      _videoError = false;

      if (_currentVideoUrl == url && _controller != null) return;

      _currentVideoUrl = url;

      await _controller?.dispose();

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
        ),
      );

      await _controller!.initialize();
      await _controller!.setLooping(true);
      await _controller!.setVolume(0); 
      await _controller!.play();

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("VIDEO ERROR: $e");
      _videoError = true;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final adAsync = ref.watch(fetchadvertisementprovider);

    return adAsync.when(
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
      data: (model) {
        if (model.data.isEmpty) return const SizedBox();

        final datum = model.data.first;

        /// ===================== 🎥 VIDEO =====================
        if (datum.video != null &&
            datum.video.toString().isNotEmpty &&
            datum.video.toString().endsWith(".mp4")) {

   
          final String videoUrl =
              "${ImageBaseUrl.baseUrl}/${datum.video}";

          _setupVideo(videoUrl);

          return Padding(
            padding: const EdgeInsets.only(top: 10,left: 7,right: 7),
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _videoError
                    ? const Center(
                        child: Icon(
                          Icons.play_disabled_rounded,
                          size: 40,
                          color: Colors.grey,
                        ),
                      )
                    : (_controller != null &&
                            _controller!.value.isInitialized)
                        ? AspectRatio(
                            aspectRatio:
                                _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
              ),
            ),
          );
        }

      
        if (datum.ads.isEmpty) return const SizedBox();

        return CarouselSlider(
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            viewportFraction: 0.95,
            enlargeCenterPage: true,
          ),
          items: datum.ads.map((ad) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "${ImageBaseUrl.baseUrl}/${ad.image}",
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
