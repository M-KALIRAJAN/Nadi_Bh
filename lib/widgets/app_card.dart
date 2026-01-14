import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final double padding;
  final double radius;
  final Color color;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.padding = 16,
    this.radius = 100, // fully round
    this.color = const Color(0xFFD7E8E2), // same mint color as image
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle, // 100% perfect circle
      ),
      child: child,
    );
  }
}

