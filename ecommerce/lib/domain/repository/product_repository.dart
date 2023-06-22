import 'package:ecommerce/domain/model/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
}
