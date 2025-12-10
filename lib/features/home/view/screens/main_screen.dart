import 'package:e_commerce/core/constants/kcolors.dart';
import 'package:e_commerce/features/cart/view/screens/cart_screen.dart';
import 'package:e_commerce/features/favorites/view/screens/favorite_screen.dart';
import 'package:e_commerce/features/home/repository/i_home_repository.dart';
import 'package:e_commerce/features/home/view/screens/home_screen.dart';
import 'package:e_commerce/features/profile/view/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:e_commerce/features/home/viewmodel/categories/categories_cubit.dart';

import '../../../../core/di/service_locator.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  late final PageController _pageController;
  late int selectedIndex;

  final List<Widget> _screens = [
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoriesCubit(sl<IHomeRepository>())..getCategories(context),
        ),
      ],
      child: const HomeScreen(),
    ),
    const FavoriteScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;

    // Initialize PageController with the initial index
    _pageController = PageController(initialPage: widget.initialIndex);

    // Optional: Listen to page changes to keep selectedIndex in sync
    _pageController.addListener(() {
      final newIndex = _pageController.page?.round() ?? selectedIndex;
      if (newIndex != selectedIndex) {
        setState(() {
          selectedIndex = newIndex;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: WaterDropNavBar(
        bottomPadding: 8,
        backgroundColor: Colors.white,
        inactiveIconColor: Colors.black87,
        waterDropColor: baseColor,
        barItems: [
          BarItem(
            filledIcon: Icons.home,
            outlinedIcon: Icons.home_outlined,
          ),
          BarItem(
            filledIcon: Icons.favorite_rounded,
            outlinedIcon: Icons.favorite_border_rounded,
          ),
          BarItem(
            filledIcon: Icons.shopping_bag_rounded,
            outlinedIcon: Icons.shopping_bag_outlined,
          ),
          BarItem(
            filledIcon: Icons.account_circle_rounded,
            outlinedIcon: Icons.account_circle_outlined,
          ),
        ],
        selectedIndex: selectedIndex,
        onItemSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutQuad,
          );
        },
      ),
    );
  }
}