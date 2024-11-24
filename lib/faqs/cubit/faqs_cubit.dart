import 'package:e_commerce/constants/kapi.dart';
import 'package:e_commerce/helpers/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../model/faqs_model.dart';

part 'faqs_state.dart';

class FAQSCubit extends Cubit<FAQSState> {
  FAQSCubit() : super(FAQSInitial());
  static List<QuestionsData> questionsData = [];

  void getFAQS() async {
    emit(FAQSLoadingState());
    try {
      final response = await DioHelpers.getData(path: Kapi.faqs);
      questionsData = FAQSModel.fromJson(response.data).data!.questionsData!;
      emit(FAQSSuccessState());
    } catch (e) {
      emit(FAQSErrorState(e.toString()));
    }
  }
}
