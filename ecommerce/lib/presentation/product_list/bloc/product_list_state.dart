import 'package:ecommerce/domain/model/product.dart';
import 'package:equatable/equatable.dart';

abstract class ProductListState extends Equatable {
  const ProductListState._();

  factory ProductListState.initialState() => const ProductListInitialState._();

  factory ProductListState.loading() => const ProductListLoadingState._();

  factory ProductListState.completed(List<Product> productList) =>
      ProductListCompletedState(productList);

  factory ProductListState.cartUpdated(count) => CartCountUpdateState(count);

  @override
  List<Object?> get props => [];
}

class ProductListInitialState extends ProductListState {
  const ProductListInitialState._() : super._();
}

class ProductListLoadingState extends ProductListState {
  const ProductListLoadingState._() : super._();
}

class ProductListCompletedState extends ProductListState {
  final List<Product> productList;

  const ProductListCompletedState(this.productList) : super._();

  @override
  List<Object?> get props => [productList];
}

class CartCountUpdateState extends ProductListState {
  final int count;

  const CartCountUpdateState(this.count) : super._();

  @override
  List<Object?> get props => [count];
}
