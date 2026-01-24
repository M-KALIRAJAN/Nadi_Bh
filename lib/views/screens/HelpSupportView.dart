import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/providers/HelpAndSuppord_Provider.dart';

class HelpSupportView extends ConsumerWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final helpAsync = ref.watch(helpandsupportprovider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Help & Support",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.btn_primery,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: helpAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (help) {
          final item = help.data.first;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(item.content),
          );
        },
      ),
    );
  }
}
