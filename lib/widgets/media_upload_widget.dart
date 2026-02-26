import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';

class MediaUploadWidget extends StatelessWidget {
  final List<XFile> images;
  final VoidCallback onAddTap;
  final Function(int index) onRemoveTap;

  const MediaUploadWidget({
    super.key,
    required this.images,
    required this.onAddTap,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          /// ADD MEDIA BUTTON
          if (index == images.length) {
            return InkWell(
              onTap: onAddTap,
              child: Container(
                width: 88,
                decoration: BoxDecoration(
                  color: AppColors.app_background_clr,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add, color: Colors.white, size: 35),
                    SizedBox(height: 4),
                    Text(
                      "Add Media",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          }
          /// IMAGE ITEM
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(images[index].path),
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                ),
              ),
              /// REMOVE ICON
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => onRemoveTap(index),
                  child: const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close, size: 16,color: Colors.black,),
                  ),
                ),
              ),
              /// VIEW ICON
              Positioned.fill(
                child: Center(
                  child: Icon(
                    Icons.remove_red_eye,
                    color: Colors.white.withOpacity(0.8),
                    size: 26,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
