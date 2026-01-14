import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/services/profile_service.dart';
import 'package:nadi_user_app/widgets/app_back.dart';
import 'package:nadi_user_app/widgets/inputs/app_text_field.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  ProfileService _profileService = ProfileService();
  Map<String, dynamic>? basicData;
  List addresses = [];
  List familyMembers = [];
  File? profileImage;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    profiledata();
  }

  Future<void> profiledata() async {
    final String? userId = await AppPreferences.getUserId();
    AppLogger.info("************************* $userId");

    if (userId == null || userId.isEmpty) {
      AppLogger.error("UserId is null or empty");
      return;
    }

    // Helper function to safely convert to string
    String safeString(dynamic value) {
      return value?.toString() ?? "";
    }

    // Check if we already stored profile data
    final cachedProfile = await AppPreferences.getProfileData();
    if (cachedProfile != null) {
      setState(() {
        basicData = cachedProfile['data'] as Map<String, dynamic>?;
        addresses = cachedProfile['addresses'] as List? ?? [];
        familyMembers = cachedProfile['familyMembers'] as List? ?? [];

        final basicInfo = basicData?['basicInfo'] ?? {};

        nameCtrl.text = safeString(basicInfo['fullName']);
        emailCtrl.text = safeString(basicInfo['email']);
        phoneCtrl.text = safeString(basicInfo['mobileNumber']);

        addressCtrl.text = addresses.isNotEmpty
            ? safeString(addresses[0]['city'])
            : "";
      });
      return; // Use cached data, no API call
    }

    // Fetch profile from API
    final Map<String, dynamic>? profileResponse = await _profileService
        .profileData(userId: userId);

    if (profileResponse == null) {
      AppLogger.error("Profile response is null");
      return;
    }

    AppLogger.info("profiledata ${jsonEncode(profileResponse)}");

    // Save to cache
    await AppPreferences.saveProfileData(profileResponse);

    setState(() {
      basicData = profileResponse['data'] as Map<String, dynamic>?;
      addresses = profileResponse['addresses'] as List? ?? [];
      familyMembers = profileResponse['familyMembers'] as List? ?? [];

      final basicInfo = basicData?['basicInfo'] ?? {};

      nameCtrl.text = safeString(basicInfo['fullName']);
      emailCtrl.text = safeString(basicInfo['email']);
      phoneCtrl.text = safeString(basicInfo['mobileNumber']);

      addressCtrl.text = addresses.isNotEmpty
          ? safeString(addresses[0]['city'])
          : "";
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    profiledata(); // reload each time widget appears
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background_clr,
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40,left: 15,right: 15),

            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentGeometry.topCenter,
                end: AlignmentGeometry.bottomCenter,
                colors: [
                  Color.fromRGBO(76, 149, 129, 1),
                  Color.fromRGBO(117, 192, 172, 1),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(51),
                bottomRight: Radius.circular(51),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppCircleIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () {
                        // () => Navigator.pop(context);
                        // context.pop();
                      },
                      color: Color.fromRGBO(183, 213, 205, 1),
                    ),
                    const Text(
                      "Profile Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Text(""),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  height: 62,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromRGBO(13, 95, 72, 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Welcome",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                nameCtrl.text.isNotEmpty
                                    ? nameCtrl.text
                                    : "Loading...",
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

                      InkWell(
                        onTap: () async {
                          if (basicData != null) {
                            final profileResponse = {
                              "data": basicData,
                              "addresses": addresses,
                              "familyMembers": familyMembers,
                            };

                            // Await for result
                            final result = await context.push<bool>(
                              RouteNames.editprfoile,
                              extra: profileResponse,
                            );
                            // If result is true, refresh profile data
                            if (result == true) {
                              profiledata(); // call your API again to refresh
                            }
                          } else {
                            AppLogger.error("Profile data is null");
                          }
                        },

                        child: Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            color: AppColors.button_secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 25,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Full Name",

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),

                    AppTextField(
                      controller: nameCtrl,
                      readonly: true,
                      enabled: false,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Email Adress",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),

                    AppTextField(
                      controller: emailCtrl,
                      readonly: true,
                      enabled: false,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Phone Number",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),

                    AppTextField(
                      controller: phoneCtrl,
                      readonly: true,
                      enabled: false,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Adress",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),

                    AppTextField(
                      minLines: 3,
                      maxLines: 5,
                      controller: addressCtrl,
                      readonly: true,
                      enabled: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}