import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/l10n/app_localizations.dart';
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
          text: addresses.isNotEmpty ? addresses[0]['city'] : '',
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

    // Ensure mobile number is numeric
    final mobileNumber = int.tryParse(mobileController.text.trim());
    if (mobileNumber == null) {
      AppLogger.error("❌ Invalid mobile number");
      return;
    }

    // Build payload as Map (not JSON string)
    final Map<String, dynamic> payload = {
      "userId": userId,
      "basicInfo": {
        "fullName": fullNameController.text.trim(),
        "email": emailController.text.trim(),
        "mobileNumber": mobileNumber,
      },
      "address": {
        "building": buildingController.text.trim(),
        "city": blockController.text.trim(),
        "floor": floorController.text.trim(),
        "aptNo": apartmentController.text.trim(),
      },
    };

    // Convert to FormData
    final Map<String, dynamic> formMap = {
      ...payload,
      if (profileImage != null)
        "image": await MultipartFile.fromFile(
          profileImage!.path,
          filename: profileImage!.path.split('/').last,
        ),
    };

    final formData = FormData.fromMap(formMap);

    AppLogger.info("📦 FormData payload keys: ${formMap.keys}");
    if (profileImage != null)
      AppLogger.info("🖼️ Image Path: ${profileImage!.path}");

    try {
      final response = await _profileService.editProfile(formData: formData);
      AppLogger.success("✅ API RESPONSE: $response");

      // Update local cache
      final updatedProfile = {
        "data": {
          "basicInfo": {
            "fullName": fullNameController.text.trim(),
            "email": emailController.text.trim(),
            "mobileNumber": mobileNumber,
            "image": response?['data']?['basicInfo']?['image'],
          },
        },
        "addresses": [
          {
            "building": buildingController.text.trim(),
            "city": blockController.text.trim(),
            "floor": floorController.text.trim(),
            "aptNo": apartmentController.text.trim(),
          },
        ],
        "familyMembers": familyMembers,
      };

      AppLogger.info("💾 Updated Local Profile Cache: $updatedProfile");
      await AppPreferences.saveProfileData(updatedProfile);

      if (mounted) context.pop(true);
    } on DioException catch (e) {
      AppLogger.error("❌ STATUS: ${e.response?.statusCode}");
      AppLogger.error("❌ DATA: ${e.response?.data}");
    } catch (e, stack) {
      AppLogger.error("❌ UNKNOWN ERROR: $e");
      AppLogger.error(stack.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
      final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      context.pop();
                    },
                  ),
                   Text(
                    loc.editProfile ?? "",
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
                              radius: 50,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: profileImage != null
                                  ? FileImage(profileImage!)
                                  : null,
                              child: profileImage == null
                                  ? Container(
                                      height: 120,
                                      width: 120,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                    )
                                  : null,
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
                       Text(
                      loc.fullName ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AppTextField(controller: fullNameController),
                      const SizedBox(height: 15),

                      // Email Address
                       Text(
                       loc.emailAddress ,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AppTextField(controller: emailController),
                      const SizedBox(height: 15),

                      // Phone Number
                       Text(
                         loc.phoneNumber ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AppTextField(controller: mobileController),
                      const SizedBox(height: 15),

                      // Building (Single field)
                       Text(
                         loc.building ?? "",
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
                                 Text(
                                  loc.city ?? "",
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
                                 Text(
                                loc.floor ?? "",
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
                       Text(
                          loc.apartment ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AppTextField(controller: apartmentController),
                      const SizedBox(height: 15),

                       Text(
                          loc.additionalInfo ?? "",
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
                              text: loc.cancel ?? "",
                              onPressed: () {
                                context.pop();
                              },
                              color: Color.fromRGBO(76, 149, 129, 1),
                              width: double.infinity,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: AppButton(
                              text: loc.save ?? "",
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
