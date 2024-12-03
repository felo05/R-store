import 'package:e_commerce/features/add_address/model/address_model.dart';
import 'package:e_commerce/features/add_address/repository/add_address_repository_implementation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_address_state.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  AddAddressCubit() : super(AddAddressInitial());

  void addAddress(AddressData addressData, BuildContext context) async {
    emit(AddAddressLoadingState());
    await AddAddressRepositoryImplementation()
        .addAddress(addressData,context)
        .then((failure) {
      if (failure == null) {
        emit(AddAddressSuccessState());
      } else {
        emit(AddAddressErrorState(failure.errorMessage.toString()));
      }
    });
  }
}
