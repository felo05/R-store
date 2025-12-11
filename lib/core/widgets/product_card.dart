import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/home/models/products_model.dart';
import '../../core/routes/app_routes.dart';
import '../localization/l10n/app_localizations.dart';
import 'custom_network_image.dart';
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
      child: Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            // Navigate to product details using named route
            Navigator.pushNamed(
              context,
              AppRoutes.productDetails,
              arguments: ProductDetailsArguments(
                product: widget.product,
                productId: widget.product.id,
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        height: widget.height.h + 2,
                        child: CustomNetworkImage(
                            height: widget.height.h,
                            image: widget.product.image ?? ""),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8.h),

                SizedBox(
                  height: (1.7 * 14 * 2).h,
                  child: CustomText(
                    text: widget.product.name ?? "",
                    textSize: 16,
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
