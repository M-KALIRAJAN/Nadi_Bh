import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/services/auth_service.dart';
import 'package:nadi_user_app/widgets/app_back.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';
import 'package:nadi_user_app/widgets/id_card.dart';


class UploadIdView extends StatefulWidget {
  const UploadIdView({super.key});

  @override
  State<UploadIdView> createState() => _UploadIdViewState();
}

class _UploadIdViewState extends State<UploadIdView> {
  File? frontImage;
  File? backImage;
  final AuthService _authService = AuthService();
  final ImagePicker picker = ImagePicker();
    bool _isLoading = false;

  Future<void> pickImage(bool isFront, ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image == null) return;

    setState(() {
      if (isFront) {
        frontImage = File(image.path);
      } else {
        backImage = File(image.path);
      }
    });
  }


Future<void> UploadIDproof(BuildContext context) async {
  if (frontImage == null || backImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: const Text("Please upload both front and back images"),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    final userId = await AppPreferences.getUserId();
    if (userId == null) throw Exception("User not found");

    final response = await _authService.uploadIdProof(
      frontImage: frontImage!,
      backImage: backImage!,
      userId: userId,
    );

    if (response != null) {
      context.push(RouteNames.Terms);
    }
  } catch (e) {

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst("Exception: ", "")),
          backgroundColor: Colors.red,
        ),
      );
  } finally {
    setState(() => _isLoading = false);
  }
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
                left: 17,
                right: 17,
                top: 10,
                bottom: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCircleIconButton(icon: Icons.arrow_back, onPressed: () {}),

                 const  Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(width: 40),
                ],
              ),
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 5),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const  Text(
                        "Upload ID Card",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 20),
                      IdCardSection(
                        title: "Front Side of ID Card",
                        subtitle:
                            "Ensure your name, photo, and expiry date are clearly visible.",
                        previewImage: frontImage,
                        onTakePhoto: () {
                          print("Take photo clicked");
                          pickImage(true, ImageSource.camera);
                        },
                        onUploadGallery: () {
                          print("Upload gallery clicked");
                          pickImage(true, ImageSource.gallery);
                        },
                      ),
                      const SizedBox(height: 20),
                      IdCardSection(
                        title: "Front Side of ID Card",
                        subtitle:
                            "Ensure your name, photo, and expiry date are clearly visible.",
                        previewImage: backImage,
                        onTakePhoto: () {
                          print("Take photo clicked");
                          pickImage(false, ImageSource.camera);
                        },
                        onUploadGallery: () {
                          pickImage(false, ImageSource.gallery);

                          print("Upload gallery clicked");
                        },
                      ),
                      SizedBox(height: 20),
                      AppButton(
                        text: "Continue",
                          isLoading: _isLoading,
                        onPressed: () {
                          UploadIDproof(context);
                        },
                        color: AppColors.btn_primery,
                        width: double.infinity,
                      ),
                      SizedBox(height: 20),
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
