import 'package:flutter/material.dart';

class PointsNodification extends StatefulWidget {
  const PointsNodification({super.key});

  @override
  State<PointsNodification> createState() => _PointsNodificationState();
}

class _PointsNodificationState extends State<PointsNodification> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: Text("Point Nodifications"),
      ),
    );
  }
}