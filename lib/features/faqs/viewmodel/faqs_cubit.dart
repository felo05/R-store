import 'package:e_commerce/features/faqs/repository/i_faqs_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/faqs_model.dart';

part 'faqs_state.dart';

class FAQSCubit extends Cubit<FAQSState> {
  final IFAQSRepository faqsRepository;
  static const int itemsPerPage = 15;

  FAQSCubit(this.faqsRepository) : super(FAQSInitial());

  void getFAQS(BuildContext context) async {
    emit(FAQSLoadingState());
    (await faqsRepository.getFaqs(context, limit: itemsPerPage)).fold((failure) {
      emit(FAQSErrorState(failure.toString()));
    }, (response) {
      emit(FAQSSuccessState(response.faqs ?? [], response.lastDocument));
    });
  }

  Future<void> loadMoreFAQS(BuildContext context, List<QuestionsData> currentFaqs, dynamic lastDocument) async {
    if (lastDocument == null) return;

    emit(FAQSLoadingMoreState(currentFaqs));

    (await faqsRepository.getFaqs(context, limit: itemsPerPage, lastDocument: lastDocument)).fold(
      (failure) {
        emit(FAQSSuccessState(currentFaqs, lastDocument)); // Keep current data on error
      },
      (response) {
        final List<QuestionsData> allFaqs = [...currentFaqs, ...(response.faqs ?? <QuestionsData>[])];
        emit(FAQSSuccessState(allFaqs, response.lastDocument));
      }
    );
  }
}
