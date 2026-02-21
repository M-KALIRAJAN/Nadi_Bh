import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:nadi_user_app/providers/language_provider.dart';
import 'package:nadi_user_app/services/onbording_service.dart';

final onbordingServiceProvider = Provider((ref) {
  return OnbordingService();
});

final aboutContentProvider = FutureProvider<List<String>>((ref) async {

  try {

    final service = ref.read(onbordingServiceProvider);

    final locale = ref.watch(languageProvider);
    final lang = locale.languageCode;

    print("Selected Language = $lang");

    final box = Hive.box("aboutBox");

    /// 👇 LANGUAGE BASED CACHE
    final hiveData =
        box.get("about_content_$lang")?.cast<String>();

    final hiveUpdatedAt =
        box.get("about_updatedAt_$lang");

    final data = await service.fetchAbout(lang);

    print("API Response = $data");

    if (data != null &&
        data["data"] != null &&
        data["data"]["content"] is List &&
        data["data"]["updatedAt"] != null) {

      final rawContent = data["data"]["content"] as List;

      final apiContent = rawContent.map<String>((item) {

        if (item is Map) {
          return item.values.first.toString();
        } else if (item is String) {
          return item;
        } else {
          return "";
        }

      }).toList();

      final apiUpdatedAt = data["data"]["updatedAt"];

      /// 👇 UPDATE CACHE PER LANGUAGE
      if (hiveData == null ||
          hiveData.isEmpty ||
          hiveUpdatedAt != apiUpdatedAt) {

        print("Updating Hive cache for $lang");

        await box.put("about_content_$lang", apiContent);
        await box.put("about_updatedAt_$lang", apiUpdatedAt);

        return apiContent;

      } else {

        print("Using cached data for $lang");

        return hiveData;
      }
    }

    return hiveData ?? [];

  } catch (e, stack) {

    print("🔥 ABOUT PROVIDER ERROR: $e");
    print(stack);

    rethrow;
  }
});
