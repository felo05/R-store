import 'package:e_commerce/core//constants/Kcolors.dart';
import 'package:e_commerce/core/widgets/back_appbar.dart';
import 'package:e_commerce/core/widgets/custom_text_field.dart';
import 'package:e_commerce/features/add_address/model/address_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../core/localization/l10n/app_localizations.dart';
import '../../core/widgets/custom_text.dart';
import '../home/main_screen.dart';
import 'cubit/add_address_cubit.dart';

class CompleteAddAddress extends StatelessWidget {
  final LatLng position;

  CompleteAddAddress({super.key, required this.position, this.placeMark});

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode cityFocusNode = FocusNode();
  final FocusNode streetFocusNode = FocusNode();
  final FocusNode detailsFocusNode = FocusNode();
  final FocusNode notesFocusNode = FocusNode();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Placemark? placeMark ;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(placeMark?.toJson());
    }
    streetController.text = placeMark?.street ?? '';
    cityController.text = placeMark?.subAdministrativeArea ?? '';
    return Scaffold(
      appBar: BackAppBar(
        title: AppLocalizations.of(context)!.add_address,
        color: baseColor,
        textColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 24.w),
          child: BlocProvider(
            create: (context) => AddAddressCubit(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  CustomTextField(
                    text: AppLocalizations.of(context)!.name,
                    controller: nameController,
                    currentFocusNode: nameFocusNode,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return AppLocalizations.of(context)!.it_cant_be_empty;
                      }
                      return null;
                    },
                    onSubmit: (input) {
                      FocusScope.of(context).requestFocus(cityFocusNode);
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    text: AppLocalizations.of(context)!.city,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return AppLocalizations.of(context)!.it_cant_be_empty;
                      }
                      return null;
                    },
                    controller: cityController,
                    currentFocusNode: cityFocusNode,
                    onSubmit: (input) {
                      FocusScope.of(context).requestFocus(streetFocusNode);
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    text: AppLocalizations.of(context)!.street,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return AppLocalizations.of(context)!.it_cant_be_empty;
                      }
                      return null;
                    },
                    controller: streetController,
                    currentFocusNode: streetFocusNode,
                    onSubmit: (input) {
                      FocusScope.of(context).requestFocus(detailsFocusNode);
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    text: AppLocalizations.of(context)!.details,
                    controller: detailsController,
                    currentFocusNode: detailsFocusNode,
                    onSubmit: (input) {
                      FocusScope.of(context).requestFocus(notesFocusNode);
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    text: AppLocalizations.of(context)!.note,
                    controller: notesController,
                    currentFocusNode: notesFocusNode,
                    onSubmit: (input) {
                      // If form is valid, submit the data
                      if (_formKey.currentState!.validate()) {
                        context.read<AddAddressCubit>().addAddress(
                              AddressData(
                                  name: nameController.text,
                                  city: cityController.text,
                                  region: streetController.text,
                                  details: detailsController.text,
                                  notes: input,
                                  latitude: position.latitude,
                                  longitude: position.longitude),context
                            );
                      }
                    },
                  ),
                  SizedBox(height: 40.h),
                  BlocConsumer<AddAddressCubit, AddAddressState>(
                    listener: (context, state) {
                      if (state is AddAddressErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else if (state is AddAddressSuccessState) {
                        Get.offAll( const MainScreen(
                              initialIndex: 2,
                            ));
                      }
                    },
                    builder: (context, state) {
                      if (state is AddAddressLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: baseColor,
                          ),
                        );
                      }
                      return InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AddAddressCubit>().addAddress(
                                AddressData(
                                    name: nameController.text,
                                    city: cityController.text,
                                    region: streetController.text,
                                    details: detailsController.text,
                                    notes: notesController.text,
                                    latitude: position.latitude,
                                    longitude: position.longitude),context);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: baseColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: CustomText(
                              text: AppLocalizations.of(context)!.add_address,
                              textColor: Colors.white,
                              textWeight: FontWeight.w500,
                              textSize: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
