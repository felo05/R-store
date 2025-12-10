import 'package:e_commerce/features/add_address/model/address_model.dart';
import 'package:e_commerce/features/add_address/repository/i_add_address_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_address_state.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  final IAddAddressRepository addAddressRepository;

  AddAddressCubit(this.addAddressRepository) : super(AddAddressInitial());

  void addAddress(AddressData addressData, BuildContext context) async {
    emit(AddAddressLoadingState());
    final result=await addAddressRepository
        .addAddress(addressData,context);
    result.fold(
          (failure) => emit(AddAddressErrorState(failure)),
          (_) => emit(AddAddressSuccessState()),
    );
  }
}
