import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';


class IncomingPointsRequestCard extends StatelessWidget {
  final String name;
  final String date;
  final String points;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const IncomingPointsRequestCard({
    super.key,
    required this.name,
    required this.date,
    required this.points,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header with avatar, name, date
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.orange.shade100,
                child: const Icon(
                  Icons.card_giftcard,
                  color: Colors.orange,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$name sent you points",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "+$points",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Actions row
Row(
  children: [
    Expanded(
      child: OutlinedButton(
        onPressed: onReject,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: BorderSide(color: Colors.red.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6),
          minimumSize: const Size(0, 40),
          visualDensity: VisualDensity.compact,
        ),
        child: const Text(
          "Reject",
          style: TextStyle(fontSize: 14),
        ),
      ),
    ),
    const SizedBox(width: 6),
    Expanded(
      child: ElevatedButton(
        onPressed: onAccept,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.button_secondary,
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          visualDensity: VisualDensity.compact,
        ),
        child: const Text(
          "Accept",
          style: TextStyle(fontSize: 14,color: Colors.white),
        ),
      ),
    ),
  ],
),


        ],
      ),
    );
  }
}
