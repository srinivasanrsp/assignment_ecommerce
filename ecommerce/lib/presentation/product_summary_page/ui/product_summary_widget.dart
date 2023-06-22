import 'package:ecommerce/domain/model/cart.dart';
import 'package:ecommerce/presentation/product_summary_page/bloc/cart_list_cubit.dart';
import 'package:ecommerce/presentation/product_list/bloc/product_item_cubit.dart';
import 'package:ecommerce/presentation/product_list/bloc/product_list_bloc.dart';
import 'package:ecommerce/presentation/product_list/bloc/product_list_event.dart';
import 'package:ecommerce/presentation/product_list/widget/quantity_change_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductSummaryWidget extends StatelessWidget {
  final ProductListBloc bloc;

  const ProductSummaryWidget(this.bloc, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      body: _pageContent(context),
    );
  }

  _pageContent(BuildContext context) {
    return BlocBuilder(
        bloc: context.read<CartListCubit>(),
        builder: (context, List<CartItem> state) {
          final List<CartItem> productList = state;
          return ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final cartItem = productList.elementAt(index);
                return BlocProvider(
                    create: (c) => ProductItemCubit(
                        quantity: bloc.getCountById(cartItem.product.id),
                        onItemUpdate: (int quantity) {
                          if (quantity == 0) {
                            context.read<CartListCubit>().removeItem(cartItem);
                          }
                          bloc.add(
                            ProductListEvent.onCartUpdate(
                                cartItem.product, quantity),
                          );
                          bloc.add(ProductListEvent.updateProductList());
                        }),
                    child: ProductSummaryItemWidget(cartItem: cartItem));
              });
        });
  }
}

class ProductSummaryItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const ProductSummaryItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final ProductItemCubit itemBloc = context.read<ProductItemCubit>();
    return SizedBox(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.product.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Expanded(
                      child: Text(
                        cartItem.product.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                BlocBuilder(
                    bloc: itemBloc,
                    builder: (c, int quantity) {
                      return QuantityChangeButton(
                        quantity: quantity,
                        onQuantityIncrease: () {
                          itemBloc.increaseCount();
                        },
                        onQuantityDecrease: () {
                          itemBloc.decreaseCount();
                        },
                      );
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
