import 'package:ecommerce/domain/model/product.dart';

abstract class ProductListEvent {
  const ProductListEvent._();

  factory ProductListEvent.fetchProducts() => const FetchEvent._();

  factory ProductListEvent.updateProductList() => const ListUpdateEvent._();

  factory ProductListEvent.onCartUpdate(product, quantity) =>
      CartUpdateEvent._(product, quantity);
}

class FetchEvent extends ProductListEvent {
  const FetchEvent._() : super._();
}

class ListUpdateEvent extends ProductListEvent {
  const ListUpdateEvent._() : super._();
}

class CartUpdateEvent extends ProductListEvent {
  final Product product;
  final int quantity;

  const CartUpdateEvent._(this.product, this.quantity) : super._();
}
