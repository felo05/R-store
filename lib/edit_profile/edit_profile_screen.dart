import 'package:e_commerce/constants/kcolors.dart';
import 'package:e_commerce/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:e_commerce/widgets/back_appbar.dart';
import 'package:e_commerce/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../login/model/profile_model.dart';
import '../widgets/custom_text.dart';

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
              ClipOval(
                child: Image.network(
                  widget.user.image!,
                  fit: BoxFit.cover,
                  width: 125,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.error));
                  },
                ),
              ),
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
                          context
                              .read<EditProfileCubit>()
                              .updateProfile(name.text, email.text, phone.text);
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
