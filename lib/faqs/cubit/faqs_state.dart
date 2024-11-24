part of 'faqs_cubit.dart';

@immutable
sealed class FAQSState {}

final class FAQSInitial extends FAQSState {}

final class FAQSErrorState extends FAQSState {
  final String message;

  FAQSErrorState(this.message);
}

final class FAQSSuccessState extends FAQSState {}

final class FAQSLoadingState extends FAQSState {}
