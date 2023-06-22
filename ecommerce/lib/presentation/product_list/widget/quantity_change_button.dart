import 'package:flutter/material.dart';

class QuantityChangeButton extends StatelessWidget {
  final int quantity;
  final VoidCallback onQuantityIncrease;
  final VoidCallback onQuantityDecrease;

  const QuantityChangeButton(
      {Key? key,
      required this.quantity,
      required this.onQuantityIncrease,
      required this.onQuantityDecrease})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          children: [
            InkWell(onTap: onQuantityDecrease, child: const Icon(Icons.remove)),
            const Padding(padding: EdgeInsets.only(right: 8)),
            Text(quantity.toString()),
            const Padding(padding: EdgeInsets.only(right: 8)),
            InkWell(onTap: onQuantityIncrease, child: const Icon(Icons.add)),
          ],
        ));
  }
}
