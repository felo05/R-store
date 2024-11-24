import 'package:e_commerce/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../constants/kcolors.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/login_and_register_header.dart';
import 'cubit/register_cubit.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController passCheckController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _checkPassFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => RegisterCubit(),
        child: Builder(
          builder: (context) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    LoginAndRegisterHeader(
                      title: AppLocalizations.of(context)!.create_new_account,
                      subTitle: AppLocalizations.of(context)!
                          .set_up_your_username_and_password,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: CustomTextField(
                        text: AppLocalizations.of(context)!.name,
                        validator: (inputText) {
                          return inputText!.length < 4
                              ? AppLocalizations.of(context)!.enter_valid_name
                              : null;
                        },
                        onSubmit: (input) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                        controller: nameController,
                        inputType: TextInputType.name,
                      ),
                    ),
                    CustomTextField(
                      currentFocusNode: _emailFocusNode,
                      text: AppLocalizations.of(context)!.email,
                      controller: emailController,
                      onSubmit: (input) {
                        FocusScope.of(context).requestFocus(_phoneFocusNode);
                      },
                      validator: (inputText) {
                        return inputText!.isEmail
                            ? null
                            : AppLocalizations.of(context)!.email_not_valid;
                      },
                      inputType: TextInputType.emailAddress,
                    ),
                    CustomTextField(
                      currentFocusNode: _phoneFocusNode,
                      text: AppLocalizations.of(context)!.phone_number,
                      controller: phoneController,
                      onSubmit: (input) {
                        FocusScope.of(context).requestFocus(_passFocusNode);
                      },
                      validator: (inputText) {
                        if (inputText!.length == 11 && inputText.isPhoneNumber) {
                          return null;
                        } else {
                          return AppLocalizations.of(context)!
                              .phone_number_not_valid;
                        }
                      },
                      inputType: TextInputType.phone,
                    ),
                    CustomTextField(
                        currentFocusNode: _passFocusNode,
                        text: AppLocalizations.of(context)!.password,
                        controller: passController,
                        isPassword: true,
                        onSubmit: (input) {
                          FocusScope.of(context).requestFocus(
                              _checkPassFocusNode);
                        },
                        validator: (inputText) {
                          if (inputText!.length < 5) {
                            return AppLocalizations.of(context)!
                                .password_has_to_be_more_than;
                          }
                          return null;
                        },
                        inputType: TextInputType.visiblePassword),
                    CustomTextField(
                        currentFocusNode: _checkPassFocusNode,
                        text: AppLocalizations.of(context)!.password_check,
                        validator: (inputText) {
                          return inputText != passController.text
                              ? AppLocalizations.of(context)!.check_password
                              : null;
                        },
                        controller: passCheckController,
                        isPassword: true,
                        bottomPadding: 20,
                        onSubmit: (input) {
                          if (_formKey.currentState?.validate() ?? false) {
                            context.read<RegisterCubit>().register(
                                name: nameController.text,
                                password: passController.text,
                                email: emailController.text,
                                phoneNum: phoneController.text);
                          }
                        },
                        inputType: TextInputType.visiblePassword),
                    BlocConsumer<RegisterCubit, RegisterState>(
                      listener: (context, state) {
                        if (state is RegisterErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: CustomText(
                                text: state.errorMsg,
                                textSize: 16,
                                textWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is RegisterLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return InkWell(
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              color: baseColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: CustomText(
                                text: AppLocalizations.of(context)!.signup,
                                textColor: Colors.white,
                                textWeight: FontWeight.w400,
                                textSize: 18,
                              ),
                            ),
                          ),
                          onTap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<RegisterCubit>().register(
                                  name: nameController.text,
                                  password: passController.text,
                                  email: emailController.text,
                                  phoneNum: phoneController.text);
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text:
                          AppLocalizations.of(context)!.already_have_an_account,
                          textSize: 14,
                          textWeight: FontWeight.w400,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.offAll(() => LoginScreen());
                          },
                          child: CustomText(
                            text: AppLocalizations.of(context)!.login,
                            textSize: 14,
                            textWeight: FontWeight.w400,
                            textColor: baseColor,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
