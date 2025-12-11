import 'package:e_commerce/features/home/models/products_model.dart';

// Response wrapper for pagination
class ProductsListResponse {
  ProductsListResponse({
    this.products,
    this.lastDocument,
  });

  List<ProductData>? products;
  dynamic lastDocument; // For pagination
}

