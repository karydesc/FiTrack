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
    final List<String> keysToBeRemoved = _transactionsBox.values
        .where((element) => element.accountId == account.id)
        .map((element) => element.id)
        .toList();
        
    _transactionsBox.deleteAll(keysToBeRemoved);
    _accountsBox.delete(account.id);
  }

  void updateAccount(String id, Account account) {
    _accountsBox.delete(id);
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

  double getAccountBalance(String id) {
    double balance = 0;

    for (var transaction in _transactionsBox.values) {
      if (transaction.accountId == id) {
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

    for (var transaction in _transactionsBox.values) {
      if (transaction.type == 'outgoing') {
        totalBalance -= transaction.amount;
      } else {
        totalBalance += transaction.amount;
      }
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

  Map<String, double> getTotalSpendingByCategory() {
    Map<String, double> categorySpendings = {};

    for (var transaction in _transactionsBox.values) {
      if (transaction.type == 'outgoing') {
        categorySpendings[transaction.category] =
            (categorySpendings[transaction.category] ?? 0) + transaction.amount;
      }
    }

    return categorySpendings;
  }

  Map<String, double> getSpendingByAccount() {
    Map<String, double> spendingMap = {};

    for (var transaction in _transactionsBox.values) {
      if (transaction.type == 'outgoing') {
        spendingMap[transaction.accountId] =
            (spendingMap[transaction.accountId] ?? 0) + transaction.amount;
      }
    }

    return spendingMap;
  }

  double getBalanceUptoDate(DateTime date, String id) {
    double balance = 0;
    for (var transaction in _transactionsBox.values) {
      if ((transaction.date.isBefore(date) ||
              transaction.date.isAtSameMomentAs(date)) &&
          transaction.accountId == id) {
        if (transaction.type == 'outgoing') {
          balance -= transaction.amount;
        } else {
          balance += transaction.amount;
        }
      }
    }
    return balance;
  }

  Map<DateTime, double> getAccountSpendingInRange(
    String id,
    DateTime start,
    DateTime end,
    double startingBalance,
  ) {
    double balance = startingBalance;
    Map<DateTime, double> spendingMap = {};

    final sortedTransactions =
        _transactionsBox.values
            .where(
              (transaction) =>
                  transaction.accountId == id &&
                  transaction.date.isAfter(start) &&
                  transaction.date.isBefore(end),
            )
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    for (var transaction in sortedTransactions) {
      if (transaction.type == 'outgoing') {
        balance -= transaction.amount;
      } else {
        balance += transaction.amount;
      }
      spendingMap[transaction.date] = balance;
    }
    return spendingMap;
  }
}
