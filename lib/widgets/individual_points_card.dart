import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';

class IndividualPointsCard extends StatelessWidget {
  final String date;
  final String text;
  final Image icon;
  final String points;
  const IndividualPointsCard({
    super.key,
    required this.date,
    required this.text,
    required this.icon,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(217, 217, 217, 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      color: AppColors.borderGrey,
                      fontSize: AppFontSizes.small,
                    ),
                  ),
                  Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color.fromRGBO(80, 80, 80, 1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                icon,
                SizedBox(width: 3),
                Text(
                  points,
                  style: TextStyle(
                    color: AppColors.btn_primery,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
