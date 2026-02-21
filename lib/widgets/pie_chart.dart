import 'package:flutter/material.dart';
import 'package:nadi_user_app/l10n/app_localizations.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/models/ServiceOverview_Model.dart';
import 'package:nadi_user_app/services/home_view_service.dart';

class DonutChartExample extends StatefulWidget {
  const DonutChartExample({super.key});

  @override
  State<DonutChartExample> createState() => _DonutChartExampleState();
}

class _DonutChartExampleState extends State<DonutChartExample> {
  final HomeViewService _homeViewService = HomeViewService();
  ServiceoverviewModel? serviceoverview;

  @override
  void initState() {
    super.initState();
    getServiceOverview();
  }

  Future<void> getServiceOverview() async {
    try {
      final response = await _homeViewService.serviceoverview();
      setState(() {
        serviceoverview = response;
      });

      AppLogger.success("Completed: ${response.serviceCompletedCount}");
      AppLogger.success("Pending: ${response.servicePendingCount}");
      AppLogger.success("Progress: ${response.serviceProgressCount}");
    } catch (e) {
      AppLogger.error("Service overview error: $e");
    }
  }

  int get totalCount {
    if (serviceoverview == null) return 0;
    return serviceoverview!.serviceCompletedCount +
        serviceoverview!.serviceProgressCount +
        serviceoverview!.servicePendingCount;
  }

  Map<String, double> buildServiceDataMap() {
    if (serviceoverview == null) return {};
      final l10n = AppLocalizations.of(context)!;
    return {
    l10n.completed: serviceoverview!.serviceCompletedCount.toDouble(),
    l10n.inProgress: serviceoverview!.serviceProgressCount.toDouble(),
    l10n.pending: serviceoverview!.servicePendingCount.toDouble(),
    };
  }

  final List<Color> serviceColors = [
    AppColors.btn_primery, // Completed
    AppColors.gold_coin, // In Progress
    Colors.grey, // Pending
  ];

  @override
  Widget build(BuildContext context) {
    if (serviceoverview == null) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: List.generate(
                3,
                (_) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  height: 16,
                  width: 120,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final serviceDataMap = buildServiceDataMap();
   final l10n = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 120,
          width: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                dataMap: serviceDataMap,
                chartRadius: 80,
                chartType: ChartType.ring,
                ringStrokeWidth: 22,
                colorList: serviceColors,
                legendOptions: const LegendOptions(showLegends: false),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValues: false,
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    totalCount.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   Text(
                    l10n.total,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 20),

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLegend(
                color: AppColors.btn_primery,
                  label: l10n.completed,
                count: serviceoverview!.serviceCompletedCount,
              ),
              _buildLegend(
                color: AppColors.gold_coin,
                label: l10n.inProgress,
                count: serviceoverview!.serviceProgressCount,
              ),
              _buildLegend(
                color: Colors.grey,
                label: l10n.pending,
                count: serviceoverview!.servicePendingCount,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend({
    required Color color,
    required String label,
    required int count,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            count.toString(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
