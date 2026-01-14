import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/widgets/app_back.dart';
import 'package:nadi_user_app/widgets/family_points_card.dart';
import 'package:nadi_user_app/widgets/individual_points_card.dart';

class PointDetails extends StatefulWidget {
  const PointDetails({super.key});

  @override
  State<PointDetails> createState() => _PointDetailsState();
}

class _PointDetailsState extends State<PointDetails> {
  String accountType = "";
  String userName = "";
  int points = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final type = await AppPreferences.getaccounttype();
    final name = await AppPreferences.getusername();
    final savedPoints = await AppPreferences.getPoints();

    if (!mounted) return;

    setState(() {
      accountType = type ?? "IA";
      userName = name ?? "";
      points = savedPoints;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background_clr,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Background Header
              Container(
                height: 200,
                width: double.infinity,
                padding: EdgeInsets.only(top: 48,left: 20,right: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(213, 155, 8, 1),
                      Color.fromRGBO(246, 201, 86, 1),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(51),
                    bottomRight: Radius.circular(51),
                  ),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCircleIconButton(
                      icon: Icons.arrow_back,
                      color: const Color(0xFFF6C956),
                      onPressed: () => Navigator.pop(context),
                    ),

                    const Text(
                      "Profile Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Positioned Profile Card
              Positioned(
                bottom: -60,
                left: 20,
                right: 20,
                child: Container(
                  height: 162,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromRGBO(217, 165, 32, 100),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 70,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          color: Color(0xFFD59B08),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.blue,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Welcome",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      userName.isEmpty
                                          ? "Loading..."
                                          : userName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Container(
                              height: 38,
                              width: 38,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Image.asset("assets/icons/gold.png"),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Your Current Points Balance",
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                           points.toString(),
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 70),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Point History",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                IndividualPointsCard(
                  date: "2025-07-28",
                  text: "Earned from daily loginsjfhiuwahgkkxnkshdirhklaewhih",
                  icon: Image.asset(
                    "assets/icons/up.png",
                    height: 15,
                    width: 15,
                  ),
                  points: "+50",
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          if (accountType == "FA")
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Family Points",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  FamilyPointsCard(
                    date: "2025-07-28",
                    text: "Earned from daily",
                    subtext: "individual points",
                    points: "500",
                  ),
                ],
              ),
            ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromRGBO(217, 165, 32, 100),
                  ),
                  child: Image.asset("assets/icons/send.png"),
                ),
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromRGBO(217, 165, 32, 100),
                  ),
                  child: Image.asset("assets/icons/add.png"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
