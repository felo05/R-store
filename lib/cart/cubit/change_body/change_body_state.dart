part of 'change_body_cubit.dart';

@immutable
sealed class ChangeBodyState {}

final class ChangeBodyInitial extends ChangeBodyState {}

final class ChangeBodyChangeState extends ChangeBodyState {}