import 'package:e_commerce/helpers/dio_helper.dart';
import 'package:e_commerce/home/main_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../constants/kapi.dart';

part 'add_address_state.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  AddAddressCubit() : super(AddAddressInitial());

  void addAddress(
      {required double latitude,
      required double longitude,
      String? notes,
      required String region,
      required String city,
      required String name,
      required String details}) async {
    emit(AddAddressLoadingState());
    try {
      await DioHelpers.postData(path: Kapi.addresses,body: {
        'latitude': latitude,
        'longitude': longitude,
        'notes':notes,
        'name':name,
        'details':details,
        'region':region,
        'city':city,
      });

      Get.offAll(() => MainScreen( selectedIndex: 1,));
      emit(AddAddressSuccessState());
    } catch (e) {
      emit(AddAddressErrorState(e.toString()));
    }
  }
}
