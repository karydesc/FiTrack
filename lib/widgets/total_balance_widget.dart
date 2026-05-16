import 'package:flutter/material.dart';

class TotalBalanceWidget extends StatelessWidget {
  final double money;
  const TotalBalanceWidget({super.key, required this.money});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Total Balance",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 0.1,
            height: 2,
          ),
        ),
        Text(
          "${money.toStringAsFixed(2)}€",
          style: const TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
