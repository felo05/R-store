part of 'add_address_cubit.dart';

@immutable
sealed class AddAddressState {}

final class AddAddressInitial extends AddAddressState {}

final class AddAddressLoadingState extends AddAddressState {}

final class AddAddressSuccessState extends AddAddressState {}

final class AddAddressErrorState extends AddAddressState {
  final String errorMessage;

  AddAddressErrorState(this.errorMessage);
}
