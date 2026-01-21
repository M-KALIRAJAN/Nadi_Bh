import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';

class IndividualPointsCard extends StatelessWidget {
  final String date;
  final String text;
  final String status;
  final String points;
  const IndividualPointsCard({
    super.key,
    required this.date,
    required this.text,

    required this.points,
    required this.status,
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
                status == "debit"
                    ? Image.asset(
                        "assets/icons/down.png",
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        "assets/icons/up.png",
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      ),
                SizedBox(width: 3),
                status == "debit"
                    ? Text(
                        " -${points}",
                        style: TextStyle(
                          color: Color.fromRGBO(187, 62, 64, 1),
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Text(
                         " +${points}",
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
