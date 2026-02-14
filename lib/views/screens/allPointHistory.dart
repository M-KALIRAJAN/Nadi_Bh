import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/Time_Date.dart';
import 'package:nadi_user_app/providers/pointshistory_provider.dart';
import 'package:nadi_user_app/widgets/individual_points_card.dart';

class AllPointHistory extends ConsumerStatefulWidget {
  const AllPointHistory({super.key});

  @override
  ConsumerState<AllPointHistory> createState() => _AllPointHistoryState();
}

class _AllPointHistoryState extends ConsumerState<AllPointHistory> {
     @override
     void initState() {
       super.initState();
      ref.refresh(pointshistoryprovider);
     }
  @override
  Widget build(BuildContext context) {

    final pointhistoryAsync = ref.watch(pointshistoryprovider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Point History",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.gold_coin,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: pointhistoryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (response) {
          final data = response.data;

          if (data.isEmpty) {
            return const Center(child: Text("No History Found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: IndividualPointsCard(
                  date: formatIsoDateForUI(item.updatedAt.toString()),
                  text: item.history,
                  status: item.status,
                  points: item.points.toString(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
