import 'package:e_commerce/features/authnetication/cubit/login_cubit/login_cubit.dart';
import 'package:e_commerce/features/authnetication/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../core/constants/Kcolors.dart';
import '../../core/widgets/custom_text.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/login_and_register_header.dart';
import '../home/main_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _passFocusNode = FocusNode();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => LoginCubit(),
        child: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: LoginAndRegisterHeader(
                    title: AppLocalizations.of(context)!.welcome_back,
                    subTitle:
                    AppLocalizations.of(context)!.log_in_to_your_account,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          text: AppLocalizations.of(context)!.email_or_phone_number,
                          controller: _emailController,
                          validator: (inputText) {
                            if (!(inputText!.isEmail || inputText.isPhoneNumber)) {
                              return AppLocalizations.of(context)!.invalid_email_or_phone;
                            }
                            return null;
                          },
                          onSubmit: (input) {
                            FocusScope.of(context).requestFocus(_passFocusNode);
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          currentFocusNode: _passFocusNode,
                          text: AppLocalizations.of(context)!.password,
                          controller: _passController,
                          isPassword: true,
                          bottomPadding: 0,
                          onSubmit: (input) {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<LoginCubit>().login(
                                  email: _emailController.text, password: input,context: context);
                            }
                          },
                          inputType: TextInputType.visiblePassword,
                          validator: (inputText) {
                            if (inputText!.length < 5) {
                              return AppLocalizations.of(context)!.password_has_to_be_more_than;
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                onTap: () {},
                                child: CustomText(
                                  text: AppLocalizations.of(context)!.forgot_password,
                                  textColor: baseColor,
                                  textWeight: FontWeight.w300,
                                  textSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Text(state.errorMsg),
                      ));
                    }
                    if (state is LoginSuccessState) {
                      Get.offAll(() =>   MainScreen(selectedIndex: 0,));
                    }
                  },
                  builder: (context, state) {
                    if (state is LoginLoadingState) {
                      return const CircularProgressIndicator(color: baseColor);
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
                            text: AppLocalizations.of(context)!.login,
                            textColor: Colors.white,
                            textWeight: FontWeight.w400,
                            textSize: 18,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<LoginCubit>().login(
                              email: _emailController.text,
                              password: _passController.text,
                              context: context);
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 15),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: AppLocalizations.of(context)!.did_not_have_an_account,
                      textSize: 14,
                      textWeight: FontWeight.w400,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offAll(() => RegisterScreen());
                      },
                      child: CustomText(
                        text: AppLocalizations.of(context)!.signup,
                        textSize: 14,
                        textWeight: FontWeight.w400,
                        textColor: baseColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
