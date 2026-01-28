import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';

class FamilyPointsCard extends StatelessWidget {
  final String text;
  final String subtext;
  final String points;

  const FamilyPointsCard({
    super.key,
    required this.text,
    required this.points,
    required this.subtext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(217, 217, 217, 0.5),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            child: ClipOval(child: Icon(Icons.person, size: 27)),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color.fromRGBO(80, 80, 80, 1),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Text(
                  "+973 $subtext",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: AppFontSizes.small,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),
          Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: Image.asset("assets/icons/gold.png"),
              ),
              const SizedBox(width: 4),
              Text(
                points,
                style: TextStyle(
                  color: Color.fromRGBO(213, 155, 8, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
