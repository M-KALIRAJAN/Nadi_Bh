import 'package:flutter/material.dart';


class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final double height;
  final double borderRadius;
  final double width;
  final Widget? icon;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.textColor = Colors.white,
    this.height = 60,
    required this.width,
    this.borderRadius = 14,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          if (!isLoading) {
            onPressed?.call();
          }
        }, //  ignore taps while loading
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // keep full color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white, // spinner color
                ),
              )
            : icon == null
                ? Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon!,
                      const SizedBox(width: 10),
                      Text(
                        text,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
 

