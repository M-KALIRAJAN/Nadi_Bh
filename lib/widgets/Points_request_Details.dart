import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/Time_Date.dart';
import 'package:nadi_user_app/providers/fetchrequestpeopledetails_provider.dart';
import 'package:nadi_user_app/services/Requests_points_people.dart';

class PointsRequestDetails extends ConsumerStatefulWidget {
  final bool isSender;
  final String points;
  final String status;
  final DateTime createdAt;
  final String? reason;
  final String? receiverId;
  final String? senderId;
  final String? currentUserId;
  final String peopleId;
  final String id;

  const PointsRequestDetails({
    super.key,
    required this.isSender,
    required this.points,
    required this.status,
    required this.createdAt,
    this.reason,
    this.receiverId,
    this.senderId,
    this.currentUserId,
    required this.id,
    required this.peopleId,
  });

  @override
  ConsumerState<PointsRequestDetails> createState() => _PointsRequestDetailsState();
}

class _PointsRequestDetailsState extends ConsumerState<PointsRequestDetails> {
  final RequestsPointsPeople _requestsPointsPeople = RequestsPointsPeople();

  Future<void> _sendacceptedPoint(String action) async {
    await _requestsPointsPeople.fetchacceptorrejectpoints(
      requestId: widget.id,
      action: action,
    );
     ref.refresh(fetchrequestpeopledetailsprovider(widget.peopleId));
  }

  Future<void> _sendPoint(String action) async {
    await _requestsPointsPeople.fetchacceptorrejectpoints(
      requestId: widget.id,
      action: action,
    );
     ref.refresh(fetchrequestpeopledetailsprovider(widget.peopleId));
  }

  @override
  Widget build(BuildContext context) {
    final bool showActionButtons =
        widget.status == "requested" &&
        widget.receiverId != null &&
        widget.currentUserId != null &&
        widget.receiverId == widget.currentUserId;

    return Align(
      alignment: widget.isSender ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Points to You",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Row(children: [
               Image.asset("assets/icons/gold.png"),
               const SizedBox(width: 5,),
                Text(
              widget.points,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: AppColors.gold_coin),
            ),
            ],),
           

            const SizedBox(height: 10),

            if (showActionButtons)
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(194, 33, 36, 1),
                      minimumSize: const Size(100, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    onPressed: () => _sendPoint("reject"),
                    child: const Text("Reject",style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 185, 8, 1),
                      minimumSize: const Size(100, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    onPressed: () => _sendacceptedPoint("accept"),
                    child: const Text("Accept",style: TextStyle(color: Colors.white),),
                  ),
                ],
              )
            else if (widget.status == "requested")
              _statusRow(
                icon: Icons.check_circle,
                color: Colors.grey,
                text: "Request Sent",
              )
            else if (widget.status == "accepted")
              _statusRow(
                icon: Icons.check_circle,
                color: Colors.green,
                text: "Request Accepted",
              )
            else if (widget.status == "rejected")
              _statusRow(
                icon: Icons.cancel,
                color: Colors.red,
                text: "Request Rejected",
              ),

            const SizedBox(height: 8),
            Text(
              formatIsoDateForUI(widget.createdAt.toString()),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusRow({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}
