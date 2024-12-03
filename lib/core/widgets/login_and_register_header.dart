import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_text.dart';

class LoginAndRegisterHeader extends StatelessWidget {
  const LoginAndRegisterHeader({
    super.key,
    required this.title,
    required this.subTitle,
  });

  final String title;
  final String subTitle;

  @override
  Column build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(top: 64.0.h, bottom: 25.h),
        child: Center(
            child: Image.asset(
          "assets/images/Logo.png",
          height: 75.h,
        )),
      ),
      CustomText(
        text: title,
        textSize: 24,
        textWeight: FontWeight.bold,
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 8,
      ),
      CustomText(
          text: subTitle,
          textColor: const Color(0xff9DA49E),
          textAlign: TextAlign.center,
          textSize: 14,
          textWeight: FontWeight.w400),
    ]);
  }
}
