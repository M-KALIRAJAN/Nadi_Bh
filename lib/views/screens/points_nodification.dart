import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nadi_user_app/providers/fetchpointsnodification.dart';

class PointsNodification extends ConsumerStatefulWidget {
  const PointsNodification({super.key});

  @override
  ConsumerState<PointsNodification> createState() => _PointsNodificationState();
}

class _PointsNodificationState extends ConsumerState<PointsNodification> {
  @override
  Widget build(BuildContext context) {
    final asyncNotifications = ref.watch(fetchpointsnodification);

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications"), centerTitle: true),
      body: asyncNotifications.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (response) {
          final notifications = response.data;

          if (notifications.isEmpty) {
            return const Center(child: Text("No notifications"));
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(fetchpointsnodification);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final n = notifications[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_active_outlined,
                          color: Colors.amber,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              n.type,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              n.message,
                              style: const TextStyle(fontSize: 13, height: 1.4),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              formatIsoDateForUI(n.time),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// ✅ Date Formatter (DateTime safe)
  String formatIsoDateForUI(DateTime dateTime) {
    try {
      final localDateTime = dateTime.toLocal();
      return DateFormat("d MMM yyyy, h:mm a").format(localDateTime);
    } catch (e) {
      return "-";
    }
  }
}
