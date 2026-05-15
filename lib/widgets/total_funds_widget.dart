import 'package:flutter/material.dart';

class TotalFundsWidget extends StatelessWidget {
  final double money;
  const TotalFundsWidget({super.key, required this.money});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Total Funds",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 0.1,
              height: 2,
            ),
          ),
          Text(
            "${money.toStringAsFixed(2)}\$",
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
