import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/providers/fetchrequestpeopledetails_provider.dart';
import 'package:nadi_user_app/providers/pointshistory_provider.dart';
import 'package:nadi_user_app/providers/userDashboard_provider.dart';
import 'package:nadi_user_app/services/point_request_with_id.dart';
import 'package:nadi_user_app/widgets/Points_request_Details.dart';

class RequestPeopleDetails extends ConsumerStatefulWidget {
  final String peopleId;
  final String fullName;
  const RequestPeopleDetails({
    super.key,
    required this.peopleId,
    required this.fullName,
  });

  @override
  ConsumerState<RequestPeopleDetails> createState() =>
      _RequestPeopleDetailsState();
}

class _RequestPeopleDetailsState extends ConsumerState<RequestPeopleDetails> {
  final TextEditingController _pointsController = TextEditingController();
  final PointRequestWithId _pointRequestWithId = PointRequestWithId();
  String? currentUserId;

  @override
  void dispose() {
    _pointsController.dispose();
    super.dispose();
  }

  Future<void> _sendpointrequest() async {
    final enteredPoints = _pointsController.text.trim();

    // Only call API if input has value
    if (enteredPoints.isEmpty) return;

    await _pointRequestWithId.fetchrequestwithid(
      receiverId: widget.peopleId,
      points: enteredPoints,
    );

    _pointsController.clear();

    ref.refresh(fetchrequestpeopledetailsprovider(widget.peopleId));
    ref.refresh(userdashboardprovider);
    ref.refresh(pointshistoryprovider);
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();
    Future.microtask(
      () => ref.refresh(fetchrequestpeopledetailsprovider(widget.peopleId)),
    );
  }

  Future<void> _loadUserId() async {
    currentUserId = await AppPreferences.getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final requestedpointspeopledetails = ref.watch(
      fetchrequestpeopledetailsprovider(widget.peopleId),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.gold_coin,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: Center(
          child: Text(widget.fullName, style: TextStyle(color: Colors.white)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 22,
              child: Text(
                widget.fullName.isNotEmpty
                    ? widget.fullName[0].toUpperCase()
                    : "?",
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: requestedpointspeopledetails.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (peopleDetails) {
                final list = peopleDetails.data;

                if (list.isEmpty) {
                  return const Center(child: Text("No requests found"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];

                    final bool isSender = item.senderId == widget.peopleId;

                    return PointsRequestDetails(
                      isSender: isSender,
                      points: item.points,
                      status: item.status,
                      createdAt: item.createdAt,
                      reason: item.reason,
                      receiverId: item.receiverId,
                      currentUserId: currentUserId,
                      id: item.id,
                      peopleId: widget.peopleId,
                      receivername:widget.fullName
                    );
                  },
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _pointsController,
                      decoration: const InputDecoration(
                        hintText: "Enter points",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD54F),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      _sendpointrequest();
                    },
                    child: const Text(
                      "Send",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
