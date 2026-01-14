import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:nadi_user_app/services/home_view_service.dart';

/// Provider
final serviceListProvider =
    NotifierProvider<ServiceListNotifier, List<Map<String, dynamic>>>(
  ServiceListNotifier.new,
);

class ServiceListNotifier extends Notifier<List<Map<String, dynamic>>> {
  final HomeViewService _service = HomeViewService();
  late final Box _box;

  @override
  List<Map<String, dynamic>> build() {
    _box = Hive.box('servicesBox');

    // load data when provider is created
    _loadServices();

    // initial state
    return [];
  }

Future<void> _loadServices() async {
  /// 1️⃣ Load offline data first
  final cached = _box.values
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  if (cached.isNotEmpty) {
    state = cached;
  }

  /// 2️⃣ Fetch API data
  final apiServices = await _service.servicelists();

  /// Create ID sets
  final apiIds = apiServices.map((e) => e['_id']).toSet();
  final hiveIds = _box.keys.cast<String>().toSet();

  /// 3️⃣ DELETE services removed from API
  for (final id in hiveIds) {
    if (!apiIds.contains(id)) {
      await _box.delete(id);
    }
  }

  /// 4️⃣ INSERT / UPDATE services
  for (final service in apiServices) {
    final String id = service['_id'];
    final cachedService = _box.get(id);

    if (cachedService == null ||
        cachedService['updatedAt'] != service['updatedAt']) {
      await _box.put(id, service);
    }
  }

  /// 5️⃣ Update UI
  state = _box.values
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
}


  /// Manual refresh
  Future<void> refresh() async {
    await _loadServices();
  }
}
  