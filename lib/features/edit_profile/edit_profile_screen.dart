import 'package:e_commerce/core//constants/kcolors.dart';
import 'package:e_commerce/core/widgets/back_appbar.dart';
import 'package:e_commerce/core/widgets/custom_text_field.dart';
import 'package:e_commerce/features/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/localization/l10n/app_localizations.dart';

import '../../core/widgets/custom_text.dart';
import '../profile/model/profile_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.user});

  final ProfileData user;

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  bool isEnabled = false;
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = widget.user.name!;
    email.text = widget.user.email!;
    phone.text = widget.user.phone!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        title: AppLocalizations.of(context)!.edit_profile,
        color: Colors.white,
        textColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const ClipOval(
                child:SizedBox(height: 125,child: Icon(Icons.person,size: 100,),)  ),
              const SizedBox(height: 20),
              CustomTextField(
                text: AppLocalizations.of(context)!.name,
                isEnabled: isEnabled,
                controller: name,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                text: AppLocalizations.of(context)!.email,
                isEnabled: isEnabled,
                controller: email,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                text: AppLocalizations.of(context)!.phone_number,
                controller: phone,
                isEnabled: isEnabled,
              ),
              const SizedBox(height: 210),
              BlocProvider(
                create: (context) => EditProfileCubit(),
                child: BlocConsumer<EditProfileCubit, EditProfileState>(
                  listener: (context, state) {
                    if (state is EditProfileErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.errorMessage),
                        backgroundColor: Colors.red,
                      ));
                    } else if (state is EditProfileSuccessState) {
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is EditProfileLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return InkWell(
                      onTap: () {
                        if (!isEnabled) {
                          setState(() {
                            isEnabled = true;
                          });
                        } else {
                          context.read<EditProfileCubit>().updateProfile(
                              name.text, email.text, phone.text, context);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: CustomText(
                            text: isEnabled
                                ? AppLocalizations.of(context)!.save_changes
                                : AppLocalizations.of(context)!.update,
                            textSize: 24,
                            textWeight: FontWeight.w500,
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
