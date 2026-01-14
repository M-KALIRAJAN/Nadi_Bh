import 'package:flutter/material.dart';

class RequestCart extends StatelessWidget {
  final String title;
   final String subtitle;
  final Color color;
  final double height;
  final double width;
  final double radius;
  final VoidCallback? onTap;
  final Image image;

  const RequestCart({
    super.key,
    required this.title,
    this.color = Colors.blue,
    this.height = 120,
    this.width = 120,
    this.radius = 14,
    this.onTap,
     this.subtitle = "", required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
                 
             Container(
              width:100 ,
               child: Text(
                    title,
                   style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
             ),  
            
          
             
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: image
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
