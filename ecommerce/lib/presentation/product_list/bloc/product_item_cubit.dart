import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItemCubit extends Cubit<int> {
  final Function(int) onItemUpdate;

  ProductItemCubit({required int quantity, required this.onItemUpdate})
      : super(quantity);

  void increaseCount() {
    emit(state + 1);
    onItemUpdate(state);
  }

  void decreaseCount() {
    emit(state - 1);
    onItemUpdate(state);
  }
}
