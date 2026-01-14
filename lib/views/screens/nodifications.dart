import 'package:flutter/material.dart';

class Nodifications extends StatefulWidget {
  const Nodifications({super.key});

  @override
  State<Nodifications> createState() => _NodificationsState();
}

class _NodificationsState extends State<Nodifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nodifications"),
      ),
    );
  }
}