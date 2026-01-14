import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';

class FamilyPointsCard extends StatelessWidget {
  final String date;
  final String text;
  final String subtext;
  final String points;

  const FamilyPointsCard({
    super.key,
    required this.date,
    required this.text,
  
    required this.points, required this.subtext,
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
            child: ClipOval(
              child: Image.asset(
                "assets/images/service.png",
                fit: BoxFit.cover,
                width: 40,
                height: 40,
              ),
            ),
          ),
          SizedBox(width: 10,),
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
                  subtext,
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

      
          Text(
            points,
            style: TextStyle(
              color: Color.fromRGBO(213, 155, 8, 1),
              fontWeight: FontWeight.w600,
              fontSize: 16
            ),
          ),
        ],
      ),
    );
  }
}
