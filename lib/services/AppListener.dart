import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/providers/fetchpointsnodification.dart';

class AppListener extends ConsumerWidget {
  final Widget child;

  const AppListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // GLOBAL WATCH
    ref.watch(fetchpointsnodification);

    return child;
  }
}
