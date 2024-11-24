import 'package:e_commerce/constants/Kcolors.dart';
import 'package:e_commerce/faqs/cubit/faqs_cubit.dart';
import 'package:e_commerce/widgets/back_appbar.dart';
import 'package:e_commerce/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'model/faqs_model.dart';

class FAQSScreen extends StatelessWidget {
  const FAQSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
          title: "FAQS", color: baseColor, textColor: Colors.black),
      body: BlocProvider(
        create: (context) => FAQSCubit()..getFAQS(),
        child: BlocConsumer<FAQSCubit, FAQSState>(
          listener: (context, state) {
            if (state is FAQSErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is FAQSSuccessState) {
              List<QuestionsData> questionsData = FAQSCubit.questionsData;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: questionsData.length,
                  itemBuilder: (context, index) {
                    return Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        title: CustomText(
                          text: questionsData[index].question!,
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
                              text: questionsData[index].answer!,
                              textSize: 18,
                              textWeight: FontWeight.w500,
                            ),
                          ),
                        ], // Icon color when collapsed
                      ),
                    );
                  },
                ),
              );
            } else if (state is FAQSLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
