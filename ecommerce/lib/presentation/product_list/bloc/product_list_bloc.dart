import 'dart:async';

import 'package:ecommerce/domain/model/cart.dart';
import 'package:ecommerce/domain/repository/product_repository.dart';
import 'package:ecommerce/presentation/product_list/bloc/product_list_event.dart';
import 'package:ecommerce/presentation/product_list/bloc/product_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ProductRepository productRepository;
  final cartCountStream = BehaviorSubject.seeded(0);
  final List<CartItem> selectedProducts = [];

  ProductListBloc(super.initialState, this.productRepository) {
    on<FetchEvent>(onProductFetchEvent);
    on<CartUpdateEvent>(onCartUpdate);
    on<ListUpdateEvent>(onListUpdate);
  }

  FutureOr<void> onProductFetchEvent(
      FetchEvent event, Emitter<ProductListState> emit) async {
    emit(ProductListState.loading());
    final productList = await productRepository.getProducts();

    emit(ProductListState.completed(productList));
  }

  FutureOr<void> onCartUpdate(
      CartUpdateEvent event, Emitter<ProductListState> emit) {
    if (event.quantity == 0) {
      selectedProducts
          .removeWhere((element) => element.product.id == event.product.id);
    } else {
      List<CartItem> filteredList = selectedProducts
          .where((element) => element.product.id == event.product.id)
          .toList();
      if (filteredList.isNotEmpty) {
        filteredList.first.quantity = event.quantity;
      } else {
        selectedProducts
            .add(CartItem(product: event.product, quantity: event.quantity));
      }
    }
    int count = 0;
    for (var element in selectedProducts) {
      count += element.quantity;
    }
    cartCountStream.value = count;
  }

  int getCountById(int id) {
    List<CartItem> filteredList =
        selectedProducts.where((element) => element.product.id == id).toList();
    if (filteredList.isNotEmpty) {
      return filteredList.first.quantity;
    }
    return 0;
  }

  FutureOr<void> onListUpdate(
      ListUpdateEvent event, Emitter<ProductListState> emit) {
    emit(ProductListState.completed(
        (state as ProductListCompletedState).productList));
  }
}
