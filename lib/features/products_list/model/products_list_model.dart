import 'package:e_commerce/features/home/models/prototype_products_model.dart';

// Response wrapper for pagination
class ProductsListResponse {
  ProductsListResponse({
    this.products,
    this.lastDocument,
  });

  List<PrototypeProductData>? products;
  dynamic lastDocument; // For pagination
}

