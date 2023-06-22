import 'package:ecommerce/domain/model/product.dart';
import 'package:ecommerce/presentation/product_summary_page/bloc/cart_list_cubit.dart';
import 'package:ecommerce/presentation/product_list/bloc/product_item_cubit.dart';
import 'package:ecommerce/presentation/product_list/bloc/product_list_bloc.dart';
import 'package:ecommerce/presentation/product_list/bloc/product_list_event.dart';
import 'package:ecommerce/presentation/product_list/bloc/product_list_state.dart';
import 'package:ecommerce/presentation/product_list/widget/quantity_change_button.dart';
import 'package:ecommerce/presentation/product_summary_page/ui/product_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildPageContent(context),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    final ProductListBloc bloc = BlocProvider.of<ProductListBloc>(context);
    bloc.add(ProductListEvent.fetchProducts());
    return Column(
      children: [
        Expanded(
          child: BlocBuilder(
              bloc: bloc,
              buildWhen: (p, c) =>
                  c is ProductListInitialState ||
                  c is ProductListCompletedState,
              builder: (_, state) {
                if (state is ProductListLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ProductListCompletedState) {
                  final List<Product> productList = state.productList;
                  return _buildProductList(productList, bloc);
                }
                return const SizedBox.shrink();
              }),
        ),
        Row(
          children: [
            const Icon(
              Icons.add_shopping_cart,
              color: Colors.green,
            ),
            StreamBuilder<int>(
                stream: bloc.cartCountStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data.toString(),
                      style: const TextStyle(fontSize: 16),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider(
                        create: (BuildContext context) =>
                            CartListCubit(bloc.selectedProducts),
                        child: ProductSummaryWidget(bloc))));
              },
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.focused)) return Colors.red;
                  return null; // Defer to the widget's default.
                }),
              ),
              child: const Text('Place Order'),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildProductList(List<Product> productList, ProductListBloc bloc) {
    return ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) {
          final Product product = productList.elementAt(index);
          return BlocProvider(
              create: (c) => ProductItemCubit(
                    quantity: bloc.getCountById(product.id),
                    onItemUpdate: (int quantity) {
                      bloc.add(
                          ProductListEvent.onCartUpdate(product, quantity));
                    },
                  ),
              child: ProductItemWidget(
                product: product,
              ));
        });
  }
}

class ProductItemWidget extends StatelessWidget {
  final Product product;

  const ProductItemWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final ProductItemCubit itemCubit = context.read<ProductItemCubit>();
    return SizedBox(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80',
              width: 120,
              height: 100,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Expanded(
                      child: Text(
                        product.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.price_change),
                        Expanded(child: Text(product.price.toString())),
                        BlocBuilder(
                            bloc: itemCubit,
                            builder: (c, int quantity) {
                              print(product.id.toString());
                              if (quantity > 0) {
                                return QuantityChangeButton(
                                  quantity: quantity,
                                  onQuantityIncrease: () {
                                    itemCubit.increaseCount();
                                  },
                                  onQuantityDecrease: () {
                                    itemCubit.decreaseCount();
                                  },
                                );
                              }
                              return InkWell(
                                onTap: () {
                                  itemCubit.increaseCount();
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 4, bottom: 4),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.green,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: const Text(
                                    'Add',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            }),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
