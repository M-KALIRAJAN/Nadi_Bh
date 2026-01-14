
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  const CommonNetworkImage({
    super.key,
    required this.imageUrl,
    this.size = 20, // default image size
  });

  bool get _isSvg => imageUrl.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isSvg
          ? SvgPicture.network(
              imageUrl,
              width: size,
              height: size,
              fit: BoxFit.contain,
            )
          : Image.network(
              imageUrl,
              width: size,
              height: size,
              fit: BoxFit.contain,
            ),
    );
  }
}

