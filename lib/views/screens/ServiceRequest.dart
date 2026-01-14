import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';
class Servicerequest extends StatelessWidget {
  const Servicerequest({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFE4ECE8), // Light green background like image
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D5F48), // Dark green
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 50),
                ),
        
                const SizedBox(height: 20),
        
                // Title
                const Text(
                  "Service request\nsubmitted successfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
        
                const SizedBox(height: 10),
        
                const Text(
                  "Your request (SRM-001) has been\nreceived and is being processed.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
        
                const SizedBox(height: 25),
        
                AppButton(
                  text: "View My Request",
                  onPressed: () {},
                  color: AppColors.btn_primery,
                  width: double.infinity,
             
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
