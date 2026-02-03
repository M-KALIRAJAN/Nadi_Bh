import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/providers/fetchpointsnodification.dart';
import 'package:nadi_user_app/services/NotificationApiService.dart';

class PointsNodification extends ConsumerStatefulWidget {
  const PointsNodification({super.key});

  @override
  ConsumerState<PointsNodification> createState() => _PointsNodificationState();
}

class _PointsNodificationState extends ConsumerState<PointsNodification> {
  final Notificationapiservice _notificationapiservice =
      Notificationapiservice();
  void _deletesingle(BuildContext context, String id) async {
    await _notificationapiservice.deleteonenotification(id: id);
  }
 void _clearallnotification() async{
  await _notificationapiservice.deleteallnotification();
 }
  @override
  Widget build(BuildContext context) {
    final asyncNotifications = ref.watch(fetchpointsnodification);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.btn_primery,
        title: const Text("Notifications",style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: () {
                _clearallnotification();
                      ref.refresh(fetchpointsnodification);
              },
              child: const Text(
                "Clear All",
                style: TextStyle(
                  color: Color.fromARGB(255, 229, 30, 30),
                  decoration: TextDecoration.underline,
                  decorationThickness: 2,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: asyncNotifications.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (response) {
          final notifications = response.data;

        if (notifications.isEmpty) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/New.png", 
          height: 160,
        ),
        const SizedBox(height: 16),
        const Text(
          "No Notifications",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "You're all caught up!",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
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

                return Dismissible(
                  key: Key(n.id), // unique key for each notification
                  direction: DismissDirection.endToStart, // swipe right to left
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) async {
                    // Remove the item locally first
                    notifications.removeAt(index);
                    _deletesingle(context, n.id);
                    ref.refresh(fetchpointsnodification);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                style:  TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                   
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                n.message,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                ),
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
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String formatIsoDateForUI(DateTime dateTime) {
    try {
      final localDateTime = dateTime.toLocal();
      return DateFormat("d MMM yyyy, h:mm a").format(localDateTime);
    } catch (e) {
      return "-";
    }
  }
}
