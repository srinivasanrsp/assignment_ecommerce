import 'package:ecommerce/domain/model/product.dart';
import 'package:ecommerce/domain/repository/product_repository.dart';

class MockProductRepositoryImpl extends ProductRepository {
  @override
  Future<List<Product>> getProducts() {
    List<Product> productList = [];
    for (int i = 1; i <= 10; i++) {
      final Product product = Product();
      product.id = 100 + i;
      product.price = i * 25 + 100;
      product.name = "Product $i";
      product.description = "desc";
      productList.add(product);
    }
    return Future.value(productList);
  }
}
