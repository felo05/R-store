import 'package:e_commerce/cart/cart_screen.dart';
import 'package:e_commerce/constants/kcolors.dart';
import 'package:e_commerce/favorites/favorite_screen.dart';
import 'package:e_commerce/home/home_screen.dart';
import 'package:e_commerce/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

import '../helpers/dio_helper.dart';

class MainScreen extends StatefulWidget {
   MainScreen({super.key,  required this.selectedIndex});
   int selectedIndex ;
  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  final PageController _pageController = PageController();


  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoriteScreen(),
    const CartScreen(),
    const ProfileScreen()
  ];

  @override
  void initState() {
    DioHelpers.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: PageView(
        controller: _pageController,
        children: [_screens[widget.selectedIndex]],
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
                outlinedIcon: Icons.favorite_border_rounded
            ),
            BarItem(
              filledIcon: Icons.shopping_bag_rounded,
              outlinedIcon: Icons.shopping_bag_outlined,
            ),
            BarItem(
                filledIcon: Icons.account_circle_rounded,
                outlinedIcon: Icons.account_circle_outlined),
          ],
          selectedIndex: widget.selectedIndex,
          onItemSelected: (index) {
            setState(() {
              widget.selectedIndex = index;
            });
            _pageController.animateToPage(widget.selectedIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad);
          }),
    );
  }
}
