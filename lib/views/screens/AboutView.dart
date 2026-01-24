import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/providers/aboutProvider.dart';

class AboutView extends ConsumerWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutAsync = ref.watch(aboutProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("About App")),
      body: aboutAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (about) {
          final item = about.data.first;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...item.content.map(
                  (text) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(text, textAlign: TextAlign.center),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Version ${item.version}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
