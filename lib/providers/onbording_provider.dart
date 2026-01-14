import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:nadi_user_app/services/onbording_service.dart';

final onbordingServiceProvider = Provider((ref) {
  return OnbordingService();
});

final aboutContentProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.read(onbordingServiceProvider);
  final box = Hive.box("aboutBox");

  final hiveData = box.get("about_content")?.cast<String>();
  final hiveUpdatedAt = box.get("about_updatedAt");

  final data = await service.fetchAbout();
  if (data != null &&
      data["data"] != null &&
      data["data"]["content"] is List &&
      data["data"]["updatedAt"] != null) {
    final rawContent = data["data"]["content"] as List;

    // 🔥 FIX HERE
    final apiContent = rawContent
        .map((item) => item.values.first.toString())
        .toList();

    final apiUpdatedAt = data["data"]["updatedAt"];

    if (hiveData == null || hiveData.isEmpty || hiveUpdatedAt != apiUpdatedAt) {
      await box.put("about_content", apiContent);
      await box.put("about_updatedAt", apiUpdatedAt);
      return apiContent;
    } else {
      return hiveData;
    }
  }

  return hiveData ?? [];
});
