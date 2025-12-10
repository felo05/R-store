
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_text.dart';
import '../../model/faqs_model.dart';

class FAQCard extends StatelessWidget {
  const FAQCard({
    super.key,
    required this.questionsData,
  });

  final QuestionsData questionsData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Theme(
          data: Theme.of(context)
              .copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: CustomText(
              text: questionsData.question!,
              textSize: 24,
              textWeight: FontWeight.w600,
              textAlign: TextAlign.start,
            ),
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            iconColor: Colors.black,
            collapsedIconColor: Colors.black,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(
                  text: questionsData.answer!,
                  textSize: 18,
                  textWeight: FontWeight.w500,
                ),
              ),
            ], // Icon color when collapsed
          ),
        ),
        const Divider()
      ],
    );
  }
}
