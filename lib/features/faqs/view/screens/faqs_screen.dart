import 'package:e_commerce/core//constants/Kcolors.dart';
import 'package:e_commerce/core//widgets/back_appbar.dart';
import 'package:e_commerce/features/faqs/repository/i_faqs_repository.dart';
import 'package:e_commerce/features/faqs/viewmodel/faqs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/localization/l10n/app_localizations.dart';

import '../../model/faqs_model.dart';
import '../widgets/faqs_card.dart';

class FAQSScreen extends StatelessWidget {
  const FAQSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
          title: AppLocalizations.of(context)!.faqs,
          color: baseColor,
          textColor: Colors.black),
      body: BlocProvider(
        create: (context) => FAQSCubit(sl<IFAQSRepository>())..getFAQS(context),
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
              List<QuestionsData> questionsData = state.questionsData;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: questionsData.length,
                  itemBuilder: (context, index) {
                    return FAQCard(questionsData: questionsData[index]);
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
