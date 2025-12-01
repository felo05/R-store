import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/core/constants/kcolors.dart';
import 'package:e_commerce/core/helpers/firebase_helper.dart';
import 'package:e_commerce/core/helpers/hive_helper.dart';
import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:e_commerce/features/change_password/change_password_screen.dart';
import 'package:e_commerce/features/edit_profile/edit_profile_screen.dart';
import 'package:e_commerce/features/orders/orders_screen.dart';
import 'package:e_commerce/features/profile/cubit/logout_cubit.dart';
import 'package:e_commerce/features/profile/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/localization/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../authnetication/login_screen.dart';
import '../faqs/faqs_screen.dart';
import '../orders/cubit/get_orders_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static ProfileData user = HiveHelper.getUser() ?? ProfileData();

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileData? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });

    // First try to get from Hive
    ProfileData? cachedUser = HiveHelper.getUser();

    if (cachedUser != null) {
      setState(() {
        user = cachedUser;
        isLoading = false;
      });
    }

    // Then fetch from Firebase to get latest data
    try {
      if (FirebaseHelper.currentUserId != null) {
        final userDoc = await FirebaseHelper.firestore
            .collection(FirebaseHelper.usersCollection)
            .doc(FirebaseHelper.currentUserId)
            .get();

        if (userDoc.exists && mounted) {
          final userData = userDoc.data()!;
          final profileData = ProfileData.fromJson(userData);
          profileData.id = FirebaseHelper.currentUserId;
          profileData.token = FirebaseHelper.currentUserId;

          // Save to Hive for offline access
          HiveHelper.setUser(profileData);
          ProfileScreen.user = profileData;

          setState(() {
            user = profileData;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading profile data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayUser = user ?? ProfileData();

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: baseColor))
          : RefreshIndicator(
              onRefresh: _loadUserData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
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
                              child: displayUser.image != null && displayUser.image!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: displayUser.image!,
                                      fit: BoxFit.cover,
                                      width: 80.w,
                                      height: 80.w,
                                      placeholder: (context, url) => Container(
                                        width: 80.w,
                                        height: 80.w,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.person),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        width: 80.w,
                                        height: 80.w,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.person),
                                      ),
                                    )
                                  : Container(
                                      width: 80.w,
                                      height: 80.w,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.person, size: 40),
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
                                    text: displayUser.name ?? "User",
                                    textSize: 20,
                                    overflow: TextOverflow.ellipsis,
                                    textWeight: FontWeight.bold,
                                    textColor: Colors.white,
                                  ),
                                  CustomText(
                                    text: displayUser.email ?? FirebaseHelper.userEmail ?? "",
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
                        onTap: () async {
                          final result = await Get.to(EditProfileScreen(user: displayUser));
                          if (result == true) {
                            _loadUserData(); // Refresh data after edit
                          }
                        },
                        text: AppLocalizations.of(context)!.edit_profile,
                        icon: Icons.edit_calendar_outlined),
                    _profileRow(
                        onTap: () {
                          Get.to( ChangePasswordScreen());
                        },
                        icon: Icons.lock_outline_rounded,
                        text: AppLocalizations.of(context)!.change_password),
                    _profileRow(
                        onTap: () {
                          Get.to( BlocProvider(
                              create: (BuildContext context) =>
                                  GetOrdersCubit()..getOrders(context),
                              child: const OrderScreen()));
                        },
                        icon: Icons.local_shipping_outlined,
                        text: AppLocalizations.of(context)!.my_orders),
                    _profileRow(
                        onTap: () {
                          Get.to( const FAQSScreen());
                        },
                        icon: Icons.help_outline,
                        text: AppLocalizations.of(context)!.faqs),
                    SizedBox(height: 30.h),
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
                                            Icon(Icons.login_outlined, size: 30.r),
                                            SizedBox(width: 15.w),
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
                            listener: (BuildContext context, LogoutState state) {
                              if (state is LogoutSuccessState) {
                                Get.offAll(() => LoginScreen());
                              }
                              if (state is LogoutErrorState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: CustomText(
                                      text: state.message,
                                      textSize: 16,
                                      textWeight: FontWeight.w500,
                                      textColor: Colors.white,
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
