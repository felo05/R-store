part of 'change_total_cubit.dart';

@immutable
sealed class ChangeTotalState {}

final class ChangeTotalInitial extends ChangeTotalState {}

final class ChangeTotalChangeState extends ChangeTotalState {}