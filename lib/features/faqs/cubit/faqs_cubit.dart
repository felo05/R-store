import 'package:e_commerce/features/faqs/repository/faqs_repository_implementation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/faqs_model.dart';

part 'faqs_state.dart';

class FAQSCubit extends Cubit<FAQSState> {
  FAQSCubit() : super(FAQSInitial());

  void getFAQS(BuildContext context) async {
    emit(FAQSLoadingState());
    (await FAQSRepositoryImplementation().getFaqs(context)).fold((failure) {
      emit(FAQSErrorState(failure.errorMessage.toString()));
    }, (data) {
      emit(FAQSSuccessState(data));
    });
  }
}
