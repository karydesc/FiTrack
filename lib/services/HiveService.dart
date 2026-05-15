import 'package:FiTrack/models/Account.dart';
import 'package:FiTrack/models/Transaction.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  final Box<Account> _accountsBox = Hive.box<Account>('accountsBox');
  final Box<Transaction> _transactionsBox = Hive.box<Transaction>(
    'transactionsBox',
  );

  ValueListenable<Box<Account>> get accountsListenable =>
      _accountsBox.listenable();
  ValueListenable<Box<Transaction>> get transactionsListenable =>
      _transactionsBox.listenable();

  void addAccount(Account account) {
    _accountsBox.put(account.id, account);
  }

  void deleteAccount(Account account) {
    final Iterable<Transaction> toBeRemoved = _transactionsBox.values.where(
      (element) => element.accountId == account.id,
    );
    _transactionsBox.deleteAll(toBeRemoved);
    _accountsBox.delete(account.id);
  }

  void updateAccount(String id, Account account) {
    _accountsBox.put(id, account);
  }

  Account? getAccount(String id) {
    return _accountsBox.get(id);
  }

  List<Account> getAllAccounts() {
    return _accountsBox.values.toList();
  }

  bool accountNameExists(String name) {
    final String cleanName = name.trim().toLowerCase();

    return _accountsBox.values.any((account) {
      return account.name.trim().toLowerCase() == cleanName;
    });
  }

  double getAccountBalance(Account account) {
    double balance = 0;

    for (var transaction in _transactionsBox.values) {
      if (transaction.accountId == account.id) {
        if (transaction.type == 'outgoing') {
          balance -= transaction.amount;
        } else {
          balance += transaction.amount;
        }
      }
    }
    return balance;
  }

  double getTotalBalance() {
    double totalBalance = 0;

    for (var account in _accountsBox.values) {
      totalBalance += getAccountBalance(account);
    }

    return totalBalance;
  }

  List<Transaction> getAllTransactions() {
    return _transactionsBox.values.toList();
  }

  void addTransaction(Transaction transaction) {
    _transactionsBox.put(transaction.id, transaction);
  }

  void deleteTransaction(Transaction transaction) {
    _transactionsBox.delete(transaction.id);
  }

  void updateTransaction(String id, Transaction transaction) {
    _transactionsBox.put(id, transaction);
  }

  Transaction? getTransaction(String id) {
    return _transactionsBox.get(id);
  }

  String? getTransactionImage(Transaction transaction) {
    return transaction.imagePath;
  }
}
