import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/services/profile_service.dart';
import 'package:nadi_user_app/widgets/app_back.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';
import 'package:nadi_user_app/widgets/inputs/app_text_field.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Map<String, dynamic>? basicData;
  List addresses = [];
  List familyMembers = [];
  final ImagePicker _pcker = ImagePicker();
  File? profileImage;
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController buildingController;
  late TextEditingController blockController;
  late TextEditingController floorController;
  late TextEditingController apartmentController;
  late TextEditingController additionalInfoController;
  ProfileService _profileService = ProfileService();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    // Read the paased data from GoRouter
    final profileResponse =
        GoRouterState.of(context).extra as Map<String, dynamic>;

    if (profileResponse != null) {
      setState(() {
        basicData = profileResponse['data'] as Map<String, dynamic>;
        addresses = profileResponse['addresses'] as List;
        familyMembers = profileResponse['familyMembers'] as List;

        //Initialize controllers with existing data
        fullNameController = TextEditingController(
          text: basicData?['basicInfo']['fullName'] ?? '',
        );
        emailController = TextEditingController(
          text: basicData?['basicInfo']['email'] ?? '',
        );
        mobileController = TextEditingController(
          text: basicData?['basicInfo']['mobileNumber']?.toString() ?? "",
        );
        buildingController = TextEditingController(
          text: addresses.isNotEmpty ? addresses[0]['building'] : '',
        );
        blockController = TextEditingController(
          text: addresses.isNotEmpty ? addresses[0]['blockId'] : '',
        );
        floorController = TextEditingController(
          text: addresses.isNotEmpty ? addresses[0]['floor']?.toString() : '',
        );
        apartmentController = TextEditingController(
          text: addresses.isNotEmpty ? addresses[0]['aptNo']?.toString() : '',
        );
        additionalInfoController = TextEditingController(text: "");
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    fullNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    buildingController.dispose();
    blockController.dispose();
    floorController.dispose();
    apartmentController.dispose();
    additionalInfoController.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _pcker.pickImage(source: source);
    if (image == null) return;
    final file = File(image.path);

    setState(() {
      profileImage = file;
    });
  }

  Future<void> saveProfile() async {
    final userId = await AppPreferences.getUserId();
    final payload = {
      "userId": userId,
      "basicInfo": {
        "fullName": fullNameController.text,
        "email": emailController.text,
        "mobileNumber": mobileController.text,
      },
      "address": {
        "building": buildingController.text,
        "blockId": blockController.text,
        "floor": floorController.text,
        "aptNo": apartmentController.text,
      },
    };
    try {
      final response = await _profileService.EditProfile(payload: payload);
      
      AppLogger.success(" Edit response :$response");
        // ✅ Update cache immediately
    final updatedProfile = {
      "data": {
        "basicInfo": {
          "fullName": fullNameController.text,
          "email": emailController.text,
          "mobileNumber": mobileController.text,
        },
     
      },
      "addresses": [
        {
          "building": buildingController.text,
          "blockId": blockController.text,
          "floor": floorController.text,
          "aptNo": apartmentController.text,
        }
      ],
      "familyMembers": familyMembers,
    };
     await AppPreferences.saveProfileData(updatedProfile);
          // Return true to indicate success
    if (mounted) {
      context.pop(true);  // <-- Pop with value
    }
    } catch (e) {
      AppLogger.error("Edit Profile :$e");
    }
    AppLogger.warn("payload $payload ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background_clr,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 20,
                bottom: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCircleIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () {
                      context.pop(context);
                    },
                  ),
                 const Text(
                    "Edit Profile",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                 const Text(""),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: profileImage != null
                                  ? FileImage(profileImage!)
                                  : const AssetImage(
                                          "assets/images/service.png",
                                        )
                                        as ImageProvider,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  pickImage(ImageSource.gallery);
                                },
                                child: Container(
                                  height: 38,
                                  width: 38,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF4C9581),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Full Name
                      const Text(
                        "Full Name",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AppTextField(controller: fullNameController),
                      const SizedBox(height: 15),

                      // Email Address
                      const Text(
                        "Email Address",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AppTextField(controller: emailController),
                      const SizedBox(height: 15),

                      // Phone Number
                      const Text(
                        "Phone Number",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AppTextField(controller: mobileController),
                      const SizedBox(height: 15),

                      // Building (Single field)
                      const Text(
                        "Building",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AppTextField(controller: buildingController),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Block",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                AppTextField(controller: blockController),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Floor",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                AppTextField(controller: floorController),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // More fields
                      const Text(
                        "Apartment",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AppTextField(controller: apartmentController),
                      const SizedBox(height: 15),

                      const Text(
                        "Additional Info",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AppTextField(
                        controller: TextEditingController(text: "N/A"),
                      ),
                      const SizedBox(height: 30),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              text: "Cancel",
                              onPressed: () {},
                              color: Color.fromRGBO(76, 149, 129, 1),
                              width: double.infinity,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: AppButton(
                              text: "Save",
                              onPressed: () {
                                saveProfile();
                              },
                              color: Color.fromRGBO(13, 95, 72, 1),
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
