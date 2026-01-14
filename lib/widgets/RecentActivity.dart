import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/CommonNetworkImage.dart';
import 'package:nadi_user_app/core/utils/Time_Date.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/models/UserLogModel%20.dart';
import 'package:nadi_user_app/services/logs_service.dart';
import 'package:shimmer/shimmer.dart';

class RecentActivity extends StatefulWidget {
  final bool limitLogs;
  const RecentActivity({super.key, this.limitLogs = true});

  @override
  State<RecentActivity> createState() => _RecentActivityState();
}
class _RecentActivityState extends State<RecentActivity> {
  LogsService _logsservice = LogsService();
  List<Userlogmodel> logs = [];

  bool _isLoding = true;
  @override
  void initState() {
    super.initState();
    LogsData();
  }

  Widget _buildSimmer() {
    return ListView.builder(
      itemCount: 7,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Container(height: 12, width: 100, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 22,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> LogsData() async {
    try {
      setState(() {
        _isLoding = true;
      });
      final response = await _logsservice.getUserLogs();
      if (!mounted) return;
      setState(() {
        logs = response;
      });
      AppLogger.success("LogsData ${logs}");
    } catch (e) {
      AppLogger.error("LogsData $e");
    } finally {
      setState(() {
        _isLoding = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_isLoding) {
      return _buildSimmer();
    }
    if (logs.isEmpty) {
      return Center(child: Text("No recent activity"));
    }
    final displaylog = widget.limitLogs
        ? (logs.length > 5 ? logs.sublist(0, 5) : logs)
        : logs;

    return ListView.builder(
      itemCount: displaylog.length,
      shrinkWrap: widget.limitLogs,
      physics: widget.limitLogs
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        final log = displaylog[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Avatar
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.button_secondary,
                    ),
                    child: Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CommonNetworkImage(
                          imageUrl: "${ImageAssetUrl.baseUrl}${log.logo}",
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  /// Text section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log.log,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatIsoDateForUI(log.time.toString() ?? ""),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  /// Status chip
                  Container(
                    height: 22,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.btn_primery,
                    ),
                    child: Center(
                      child: Text(
                        log.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.borderGrey, height: 1),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
