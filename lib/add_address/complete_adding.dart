import 'package:e_commerce/constants/Kcolors.dart';
import 'package:e_commerce/widgets/back_appbar.dart';
import 'package:e_commerce/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/custom_text.dart';
import 'cubit/add_address_cubit.dart';

class CompleteAddAddress extends StatelessWidget {
  final LatLng position;

  CompleteAddAddress({super.key, required this.position});

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode cityFocusNode = FocusNode();
  final FocusNode regionFocusNode = FocusNode();
  final FocusNode detailsFocusNode = FocusNode();
  final FocusNode notesFocusNode = FocusNode();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        title: "Add Address",
        color: baseColor,
        textColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 24.w),
          child: BlocProvider(
            create: (context) => AddAddressCubit(),
            child: Form(
              key: _formKey, // Attach form key here
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  CustomTextField(
                    text: "Name",
                    controller: nameController,
                    currentFocusNode: nameFocusNode,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "It can't be empty";
                      }
                      return null;
                    },
                    onSubmit: (input) {
                      FocusScope.of(context).requestFocus(cityFocusNode);
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    text: "City",
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "It can't be empty";
                      }
                      return null;
                    },
                    controller: cityController,
                    currentFocusNode: cityFocusNode,
                    onSubmit: (input) {
                      FocusScope.of(context).requestFocus(regionFocusNode);
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    text: "Region",
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "It can't be empty";
                      }
                      return null;
                    },
                    controller: regionController,
                    currentFocusNode: regionFocusNode,
                    onSubmit: (input) {
                      FocusScope.of(context).requestFocus(detailsFocusNode);
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    text: "Details",
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "It can't be empty";
                      }
                      return null;
                    },
                    controller: detailsController,
                    currentFocusNode: detailsFocusNode,
                    onSubmit: (input) {
                      FocusScope.of(context).requestFocus(notesFocusNode);
                    },
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    text: "Notes",

                    controller: notesController,
                    currentFocusNode: notesFocusNode,
                    onSubmit: (input) {
                      // If form is valid, submit the data
                      if (_formKey.currentState!.validate()) {
                        context.read<AddAddressCubit>().addAddress(
                          latitude: position.latitude,
                          longitude: position.longitude,
                          name: nameController.text,
                          city: cityController.text,
                          region: regionController.text,
                          details: detailsController.text,
                          notes: input,
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
                        Navigator.pop(context);
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
                          // Trigger validation before adding the address
                          if (_formKey.currentState!.validate()) {
                            context.read<AddAddressCubit>().addAddress(
                              latitude: position.latitude,
                              longitude: position.longitude,
                              name: nameController.text,
                              city: cityController.text,
                              region: regionController.text,
                              details: detailsController.text,
                              notes: notesController.text,
                            );
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
                          child: const Center(
                            child: CustomText(
                              text: "Add Address",
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
