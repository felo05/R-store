import 'package:e_commerce/core/widgets/back_appbar.dart';
import 'package:e_commerce/features/change_password/repository/i_change_password_repository.dart';
import 'package:e_commerce/features/change_password/viewmodel/change_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/constants/Kcolors.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../../core/widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
          title: AppLocalizations.of(context)!.change_password,
          color: Colors.white,
          textColor: Colors.black),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 45,
              ),
              CustomTextField(
                text: AppLocalizations.of(context)!.old_password,
                controller: oldPasswordController,
                isPassword: true,
                validator: (inputText) {
                  if (inputText!.length < 5) {
                    return AppLocalizations.of(context)!
                        .password_has_to_be_more_than;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                text: AppLocalizations.of(context)!.new_password,
                isPassword: true,
                controller: newPasswordController,
                validator: (inputText) {
                  if (inputText!.length < 5) {
                    return AppLocalizations.of(context)!
                        .password_has_to_be_more_than;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                text: AppLocalizations.of(context)!.check_password,
                isPassword: true,
                controller: confirmPasswordController,
                validator: (inputText) {
                  if (inputText != newPasswordController.text) {
                    return AppLocalizations.of(context)!
                        .password_has_to_be_more_than;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 265,
              ),
              BlocProvider(
                create: (context) => ChangePasswordCubit(sl<IChangePasswordRepository>()),
                child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
                  listener: (context, state) {
                    if (state is ChangePasswordErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.msg),
                      ));
                    }
                    if (state is ChangePasswordSuccessState) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.password_changed),
                      ));
                    }
                  },
                  builder: (context, state) {
                    if (state is ChangePasswordLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return InkWell(
                        onTap: () {
                          context.read<ChangePasswordCubit>().changePassword(
                              oldPasswordController.text,
                              newPasswordController.text,
                              context);
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            decoration: BoxDecoration(
                                color: baseColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: CustomText(
                                text: AppLocalizations.of(context)!
                                    .change_password,
                                textSize: 24,
                                textWeight: FontWeight.w500,
                                textColor: Colors.white,
                              ),
                            )));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
