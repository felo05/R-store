import 'package:e_commerce/constants/kcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableCustomText extends StatefulWidget {
  const ExpandableCustomText({
    Key? key,
    required this.text,
    required this.textSize,
    required this.textWeight,
    this.textAlign,
    this.textColor,
    this.overflow,
    this.maxLines = 3,
  }) : super(key: key);

  final String text;
  final double textSize;
  final FontWeight textWeight;
  final Color? textColor;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int maxLines;

  @override
  ExpandableCustomTextState createState() => ExpandableCustomTextState();
}

class ExpandableCustomTextState extends State<ExpandableCustomText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: widget.text,
          textAlign: widget.textAlign,
          overflow: widget.overflow,
          maxLines: _isExpanded ? null : widget.maxLines,
          textColor: widget.textColor,
          textWeight: widget.textWeight,
          textSize: widget.textSize,
        ),
        if (widget.text.length > 100) // Optional: Check if text is long enough
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded
                  ? AppLocalizations.of(context)!.see_less
                  : AppLocalizations.of(context)!.see_more,
              style: const TextStyle(color: baseColor),
            ),
          ),
      ],
    );
  }
}

class CustomText extends StatelessWidget {
  const CustomText({
    Key? key,
    required this.text,
    required this.textSize,
    required this.textWeight,
    this.textAlign,
    this.textColor,
    this.overflow,
    this.maxLines,
    this.lineThrough = false,
  }) : super(key: key);

  final String text;
  final double textSize;
  final FontWeight textWeight;
  final Color? textColor;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool lineThrough;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        decoration:
            lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
        decorationColor: textColor,
        decorationThickness: 2,
        color: textColor,
        fontFamily: "Poppins",
        fontWeight: textWeight,
        fontSize: textSize.sp,
      ),
    );
  }
}
