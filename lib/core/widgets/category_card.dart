import 'package:e_commerce/core/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../features/category_products/category_products_screen.dart';
import '../../features/home/models/categories_model.dart';
import 'custom_text.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
  });

  final CategoriesData category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(CategoryProductsScreen(
            title: category.name!, categoryID: category.id!.toInt()));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            child: Column(
              children: [
                Expanded(
                  child: CustomNetworkImage(image: category.image??""),
                ),
                SizedBox(height: 5.h),
                CustomText(
                  text: category.name ?? '',
                  textSize: 14,
                  textWeight: FontWeight.bold,
                  textColor: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
