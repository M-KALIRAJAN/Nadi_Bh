import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';

class IdCardSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTakePhoto;
  final VoidCallback? onUploadGallery;
  final File? previewImage;

  const IdCardSection({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTakePhoto,
    this.onUploadGallery,
    this.previewImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),

          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),

          previewImage == null
              ? Container(
                  height: 146,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 80,
                          child: previewImage == null
                              ? const Center(child: Text("Photo"))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(
                                    previewImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),

                        const SizedBox(width: 12),

                        // GREY PLACEHOLDER LINES
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _line(150),
                              const SizedBox(height: 18),
                              _line(130),
                              const SizedBox(height: 18),
                              _line(120),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  height: 146,
                  width: 270,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.file(previewImage!, fit: BoxFit.cover),
                ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onTakePhoto,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                "Take Photo",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // UPLOAD GALLERY BUTTON
          SizedBox(
            height: 47,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(76, 149, 129, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onUploadGallery,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Upload Gallery",
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.file_upload_outlined,
                      size: 27,
                      color: AppColors.btn_primery,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // small grey line
  Widget _line(double width) {
    return Container(
      height: 3,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
