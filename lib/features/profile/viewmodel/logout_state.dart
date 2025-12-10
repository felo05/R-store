part of 'logout_cubit.dart';

@immutable
sealed class LogoutState {}

final class LogoutInitial extends LogoutState {}

final class LogoutSuccessState extends LogoutState {}

final class LogoutErrorState extends LogoutState {
  final String message;

  LogoutErrorState(this.message);
}

final class LogoutLoadingState extends LogoutState {}
