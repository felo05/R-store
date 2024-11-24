import 'package:e_commerce/constants/kcolors.dart';
import 'package:e_commerce/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HorizontalProductsHeader extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const HorizontalProductsHeader(
      {super.key, required this.text, this.onPressed});

  @override
  Row build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(text: text, textSize: 20, textWeight: FontWeight.bold),
        TextButton(
            onPressed: onPressed,
            child: CustomText(
                text: AppLocalizations.of(context)!.see_more,
                textSize: 17,
                textWeight: FontWeight.w500,
                textColor: baseColor))
      ],
    );
  }
}
