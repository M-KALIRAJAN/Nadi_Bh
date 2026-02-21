import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:nadi_user_app/providers/language_provider.dart';
import 'package:nadi_user_app/services/home_view_service.dart';

/// Provider
final serviceListProvider =
    NotifierProvider<ServiceListNotifier, List<Map<String, dynamic>>>(
  ServiceListNotifier.new,
);

class ServiceListNotifier extends Notifier<List<Map<String, dynamic>>> {
  final HomeViewService _service = HomeViewService();
  Box? _box; // Make nullable to safely initialize once

  @override
  List<Map<String, dynamic>> build() {
    // Initialize Hive box only once
    _box ??= Hive.box('servicesBox');

    // Watch language changes and reload automatically
    ref.listen<Locale>(languageProvider, (previous, next) {
      final lang = next.languageCode;
      _loadServices(lang);
    });

    // Load services for the current language initially
    final currentLang = ref.watch(languageProvider).languageCode;
    _loadServices(currentLang);

    return [];
  }

  /// Load services for the given language
  Future<void> _loadServices(String lang) async {
    if (_box == null) return; // Safety check

    // 1️⃣ Load cached data for this language
    final cached = _box!.values
        .where((e) => e['lang'] == lang)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    if (cached.isNotEmpty) {
      state = cached;
    }

    try {
      // 2️⃣ Fetch data from API
      final apiServices = await _service.servicelists(lang);

      // 3️⃣ Update Hive with language-specific keys
      final apiKeys = apiServices.map((s) => '${lang}_${s['_id']}').toSet();
      final hiveKeys = _box!.keys.cast<String>().toSet();

      // Delete removed services (for this language only)
      for (final key in hiveKeys) {
        if (key.startsWith('${lang}_') && !apiKeys.contains(key)) {
          await _box!.delete(key);
        }
      }

      // Insert or update services
      for (final service in apiServices) {
        final key = '${lang}_${service['_id']}';
        final cachedService = _box!.get(key);

        if (cachedService == null ||
            cachedService['updatedAt'] != service['updatedAt']) {
          await _box!.put(key, {...service, 'lang': lang});
        }
      }

      // 4️⃣ Update state
      final updatedList = _box!.values
          .where((e) => e['lang'] == lang)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      state = updatedList;
    } catch (e) {
      // Optional: log error but keep cached state
      print("Error loading services: $e");
    }
  }

  /// Manual refresh (optional)
  Future<void> refresh() async {
    final lang = ref.read(languageProvider).languageCode;
    await _loadServices(lang);
  }
}
