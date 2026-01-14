import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:nadi_user_app/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final getBlockProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.read(authServiceProvider);

  if (!Hive.isBoxOpen("blockbox")) {
    await Hive.openBox("blockbox");
  }

  final box = Hive.box("blockbox");

  final hiveData = box.get("block_lists");
  final hiveUpdatedAt = box.get("block_updatedAt");

  final apiData = await service.selectblock();

  // API failed → fallback to hive
  if (apiData.isEmpty) {
    if (hiveData == null) return [];
    return List<Map<String, dynamic>>.from(
      (hiveData as List).map((e) => Map<String, dynamic>.from(e)),
    );
  }

  // 🔥 Proper casting
  final List<Map<String, dynamic>> blocks =
      apiData.map((e) => Map<String, dynamic>.from(e)).toList();

  // 🔥 Correct updatedAt calculation
  DateTime latest = DateTime.fromMillisecondsSinceEpoch(0);
  for (final block in blocks) {
    if (block["updatedAt"] != null) {
      final updated = DateTime.parse(block["updatedAt"]);
      if (updated.isAfter(latest)) latest = updated;
    }
  }

  final apiUpdatedAt = latest.toIso8601String();

  if (hiveData == null ||
      hiveData.isEmpty ||
      hiveUpdatedAt != apiUpdatedAt) {
    await box.put("block_lists", blocks);
    await box.put("block_updatedAt", apiUpdatedAt);
  }

  return blocks;
});
