import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/providers/Privacypolicy_Provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyView extends ConsumerWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacyAsync = ref.watch(Privacypolicyprovider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privacy Policy",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.btn_primery,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: privacyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (privacy) {
          final item = privacy.data.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: "${ImageBaseUrl.baseUrl}/${item.media}",
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                ...item.content.map(
                  (text) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(text, textAlign: TextAlign.center),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await launchUrl(
                      Uri.parse(item.link),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Text(
                    item.link,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
