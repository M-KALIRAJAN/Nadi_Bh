import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ServiceRequestCardShimmer extends StatelessWidget {
  const ServiceRequestCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 177,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Circle icon
                  Container(
                    height: 48,
                    width: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _line(width: 120, height: 14),
                      const SizedBox(height: 8),
                      _line(width: 80, height: 12),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 15),

              _line(width: double.infinity, height: 12),

              const SizedBox(height: 15),
              Container(height: 1, color: Colors.white),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _box(width: 135, height: 32),
                  _box(width: 135, height: 31),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _line({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      color: Colors.white,
    );
  }

  Widget _box({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
    );
  }
}
