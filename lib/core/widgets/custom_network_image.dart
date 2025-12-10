import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    this.height,
    required this.image,
    this.fit,
  });

  final double? height;
  final String image;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      height: height?.h,
      fit: fit ?? BoxFit.contain,
      // Cache configuration for better performance
      maxHeightDiskCache: 1000,
      maxWidthDiskCache: 1000,
      memCacheHeight: height != null ? (height! * 1.5).toInt() : null,
      memCacheWidth: height != null ? (height! * 1.5).toInt() : null,
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          const Center(child: Icon(Icons.error)),
    );
  }
}
