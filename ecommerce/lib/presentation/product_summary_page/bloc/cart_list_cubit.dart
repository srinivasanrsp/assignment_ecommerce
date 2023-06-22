import 'package:ecommerce/domain/model/cart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartListCubit extends Cubit<List<CartItem>> {
  CartListCubit(super.initialState);

  void addNewItem(CartItem cartItem) {
    state.add(cartItem);
    emit(state);
  }

  void removeItem(CartItem cartItem) {
    state.removeWhere((element) => element.product.id == cartItem.product.id);
    emit(state);
  }
}
