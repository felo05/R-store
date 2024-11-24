import 'package:e_commerce/home/cubits/add_favorite/add_favorite_cubit.dart';
import 'package:e_commerce/home/cubits/products/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

import '../../home/models/products_model.dart';
import '../../product_details/product_details_screen.dart';
import 'custom_text.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.height,
    required this.isInHome,
    required this.reloadAll,
  });

  final double height;
  final ProductData product;
  final bool? isInHome;
  final bool reloadAll;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          if (widget.product.images!.isNotEmpty &&
              widget.product.discount != null) {
            Get.to(() => ProductDetailsScreen(product: widget.product));
          } else {
            ProductsCubit()
                .getAProduct(widget.product.id!.toInt())
                .then((value) {
              Get.to(() => ProductDetailsScreen(product: value));
            });
          }
        },
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        height: widget.height.h,
                        child: Image.network(
                          widget.product.image ?? "",
                          height: widget.height.h,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.error),
                            );
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          widget.product.inFavorites ?? true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.product.inFavorites =
                                !(widget.product.inFavorites ?? true);
                          });
                          AddFavoriteCubit().addFavorite(
                              widget.product.id!.toInt(),
                              context,
                              widget.isInHome,
                              widget.reloadAll);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                SizedBox(
                  height: (1.5 * 14 * 2).h,
                  child: CustomText(
                    text: widget.product.name ?? "",
                    textSize: 14,
                    textWeight: FontWeight.bold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 4.h),

                // Price row
                Row(
                  children: [
                    CustomText(
                      text: '\$${widget.product.price}',
                      textWeight: FontWeight.bold,
                      textSize: 18,
                      textColor: Colors.black87,
                    ),
                    const Spacer(),
                    if (widget.product.discount != 0 &&
                        widget.product.discount != null)
                      CustomText(
                        text:
                            '%${widget.product.discount}  ${AppLocalizations.of(context)!.off}',
                        textColor: Colors.grey,
                        textSize: 16,
                        textWeight: FontWeight.w400,
                      ),
                    const Padding(padding: EdgeInsets.only(left: 7)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
