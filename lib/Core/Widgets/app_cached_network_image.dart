// ignore_for_file: must_be_immutable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppCasedNetworkImage extends StatelessWidget {
  AppCasedNetworkImage(
      {super.key, required this.imageUrl, this.fit, this.height, this.width});
  String imageUrl;
  BoxFit? fit;
  double? height;
  double? width;
  Future<bool> isImageAvailable(String url) async {
    try {
      final response = await Dio().head(url);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<bool>(
          future: isImageAvailable(imageUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data == false) {
              return Center(
                child: Image.asset(
                  'assets/image/task_img.png',
                  height: height?.h ?? 100.h,
                  width: width?.w ?? 200.w,
                  fit: fit ?? BoxFit.cover,
                ),
              );
            }

            return Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/placeholder.png',
                    height: height?.h ?? 200.h,
                    width: width?.w ?? 200.w,
                    fit: fit ?? BoxFit.fitHeight,
                  );
                },
              ),
            );
          }),
    );
  }
}
