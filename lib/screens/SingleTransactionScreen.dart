import 'dart:io';

import 'package:FiTrack/models/Transaction.dart';
import 'package:FiTrack/services/HiveService.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class SingleTransactionScreen extends StatelessWidget {
  final Transaction transaction;
  final Function(Transaction?) addOrEditTransactionModal;
  final BuildContext context;

  const SingleTransactionScreen({
    super.key,
    required this.context,
    required this.transaction,
    required this.addOrEditTransactionModal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            borderRadius: BorderRadius.circular(24),
            onSelected: (String value) {
              if (value == 'edit') {
                addOrEditTransactionModal(transaction);
              } else if (value == 'delete') {
                HiveService().deleteTransaction(transaction);
                Navigator.pop(context);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Delete', style: TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
        title: const Text("Transaction Details"),
        titleTextStyle: const TextStyle(fontSize: 24),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveService().transactionsListenable,
        builder: (context, Box<Transaction> box, child) {
          final liveTransaction = HiveService().getTransaction(transaction.id);

          if (liveTransaction == null) {
            return const Scaffold(body: SizedBox.shrink());
          }

          final bool isOutgoing = liveTransaction.type == 'outgoing';
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Theme.of(context).primaryColor, Colors.white],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(

                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(68, 0, 0, 0),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: isOutgoing
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                            child: Icon(
                              isOutgoing
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: isOutgoing
                                  ? Colors.red.shade400
                                  : Colors.green.shade500,
                              size: 36,
                            ),
                          ),
                          const SizedBox(height: 24),

                          Text(
                            "${isOutgoing ? '-' : '+'}${liveTransaction.getAmount().toStringAsFixed(2)} €",
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                              color: isOutgoing
                                  ? Colors.red.shade700
                                  : Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            liveTransaction.text,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 32),
                          Divider(color: Colors.grey.shade200, thickness: 1.5),
                          const SizedBox(height: 24),

                          _buildDetailRow(
                            Icons.category_outlined,
                            "Category",
                            liveTransaction.category,
                          ),
                          const SizedBox(height: 20),
                          _buildDetailRow(
                            Icons.calendar_today_outlined,
                            "Date",
                            "${liveTransaction.date.day}/${liveTransaction.date.month}/${liveTransaction.date.year}",
                          ),
                          const SizedBox(height: 20),
                          _buildDetailRow(
                            Icons.account_balance_wallet_outlined,
                            "Account ID",
                            liveTransaction.accountId,
                          ),
                          if (liveTransaction.imagePath != null) ...[
                            const SizedBox(height: 32),
                            const Divider(),
                            const SizedBox(height: 16),
                            const Text(
                              "Receipt Attached",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                File(liveTransaction.imagePath!),
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.grey.shade600, size: 20),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
