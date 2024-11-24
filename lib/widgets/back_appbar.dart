import 'package:flutter/material.dart';

import 'custom_text.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color color ;
  final Color textColor;
  const BackAppBar({super.key, required this.title, required this.color, required this.textColor,});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color,
      centerTitle: true,
      leading: IconButton(
          icon:  Icon(
            Icons.arrow_back_ios,
            color: textColor,
          ),
          onPressed: () => Navigator.pop(context)),
      title: CustomText(
        text: title,
        textSize: 22,
        textColor: textColor,
        textWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}