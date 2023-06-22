import 'package:ecommerce/domain/model/product.dart';

class CartItem {
  late int quantity;
  late Product product;

  CartItem({required this.product, this.quantity = 0}) : super();
}
