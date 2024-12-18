import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/core/constants/kcolors.dart';
import 'package:e_commerce/core/helpers/hive_helper.dart';
import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:e_commerce/features/change_password/change_password_screen.dart';
import 'package:e_commerce/features/edit_profile/edit_profile_screen.dart';
import 'package:e_commerce/features/orders/orders_screen.dart';
import 'package:e_commerce/features/profile/cubit/logout_cubit.dart';
import 'package:e_commerce/features/profile/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../authnetication/login_screen.dart';
import '../faqs/faqs_screen.dart';
import '../orders/cubit/get_orders_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static ProfileData user = HiveHelper.getUser() ?? ProfileData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: baseColor,
        centerTitle: true,
        title: CustomText(
          text: AppLocalizations.of(context)!.my_profile,
          textSize: 22,
          textColor: Colors.white,
          textWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 135.h,
            decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.r),
                    bottomRight: Radius.circular(50.r))),
            child: Padding(
              padding: EdgeInsets.all(16.0.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child:CachedNetworkImage(imageUrl: user.image ?? "", fit: BoxFit.cover,
                      placeholder: (context, url) => Container(width: 80.w,),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SizedBox(
                    width: 240.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          text: user.name ?? "",
                          textSize: 20,
                          overflow: TextOverflow.ellipsis,
                          textWeight: FontWeight.bold,
                          textColor: Colors.white,
                        ),
                        CustomText(
                          text: user.email ?? "",
                          overflow: TextOverflow.ellipsis,
                          textColor: Colors.white,
                          textSize: 18,
                          textWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5.h),
          _profileRow(
              onTap: () {
                Get.to(() => EditProfileScreen(user: user));
              },
              text: AppLocalizations.of(context)!.edit_profile,
              icon: Icons.edit_calendar_outlined),
          _profileRow(
              onTap: () {
                Get.to(() => ChangePasswordScreen());
              },
              icon: Icons.lock_outline_rounded,
              text: AppLocalizations.of(context)!.change_password),
          _profileRow(
              onTap: () {
                Get.to(() => BlocProvider(
                    create: (BuildContext context) =>
                        GetOrdersCubit()..getOrders(context),
                    child: const OrderScreen()));
              },
              icon: Icons.local_shipping_outlined,
              text: AppLocalizations.of(context)!.my_orders),
          _profileRow(
              onTap: () {
                Get.to(() => const FAQSScreen());
              },
              icon: Icons.help_outline,
              text: AppLocalizations.of(context)!.faqs),
          SizedBox(
            height: 30.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
            child: Center(
              child: BlocProvider(
                create: (context) => LogoutCubit(),
                child: BlocConsumer<LogoutCubit, LogoutState>(
                  builder: (context, state) {
                    if (state is LogoutLoadingState) {
                      return const CircularProgressIndicator();
                    }
                    return InkWell(
                        onTap: () {
                          context.read<LogoutCubit>().logout(context);
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: 60.h,
                            decoration: BoxDecoration(
                                color: baseColor,
                                borderRadius: BorderRadius.circular(15.r)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.login_outlined,
                                    size: 30.r,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  CustomText(
                                    text: AppLocalizations.of(context)!.logout,
                                    textSize: 24,
                                    textWeight: FontWeight.w500,
                                    textColor: Colors.white,
                                  ),
                                ],
                              ),
                            )));
                  },
                  listener: (context, state) {
                    if (state is LogoutSuccessState) {
                      Get.offAll(LoginScreen());
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _profileRow(
      {required Function() onTap, required icon, required String text}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 28, left: 28, top: 20, bottom: 25),
          child: Row(
            children: [
              Icon(
                icon,
                size: 30.r,
              ),
              SizedBox(width: 15.w),
              CustomText(
                text: text,
                textSize: 24,
                textWeight: FontWeight.w500,
                textColor: const Color(0xff101811),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
      ),
    );
  }
}
