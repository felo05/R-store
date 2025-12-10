import 'package:e_commerce/features/faqs/repository/i_faqs_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/faqs_model.dart';

part 'faqs_state.dart';

class FAQSCubit extends Cubit<FAQSState> {
  final IFAQSRepository faqsRepository;

  FAQSCubit(this.faqsRepository) : super(FAQSInitial());

  void getFAQS(BuildContext context) async {
    emit(FAQSLoadingState());
    (await faqsRepository.getFaqs(context)).fold((failure) {
      emit(FAQSErrorState(failure.toString()));
    }, (data) {
      emit(FAQSSuccessState(data));
    });
  }
}
