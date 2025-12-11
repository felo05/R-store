part of 'faqs_cubit.dart';

@immutable
sealed class FAQSState {}

final class FAQSInitial extends FAQSState {}

final class FAQSErrorState extends FAQSState {
  final String message;

  FAQSErrorState(this.message);
}

final class FAQSLoadingMoreState extends FAQSState {
  final List<QuestionsData> currentFaqs;

  FAQSLoadingMoreState(this.currentFaqs);
}

final class FAQSSuccessState extends FAQSState {
  final List<QuestionsData> questionsData;
  final dynamic lastDocument;

  FAQSSuccessState(this.questionsData, this.lastDocument);
}

final class FAQSLoadingState extends FAQSState {}
