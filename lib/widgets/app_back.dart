import 'package:flutter/material.dart';

class AppCircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final Color iconcolor;
  const AppCircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  this.color = const Color.fromRGBO(183, 213, 205, 1),
    this.iconcolor =  Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onPressed ,
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: IconButton(
          icon: Icon(icon, color: iconcolor, size: 17),
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
    );
  }
}
