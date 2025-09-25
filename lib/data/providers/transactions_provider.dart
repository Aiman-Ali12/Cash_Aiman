import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/transaction_model.dart';

class TransactionsProvider with ChangeNotifier {
  List<CashTransaction> _items = [];
  final DBHelper _db = DBHelper();

  List<CashTransaction> get items => _items;

  Future loadTransactions() async {
    _items = await _db.getAllTransactions();
    notifyListeners();
  }

  Future addTransaction(CashTransaction t) async {
    await _db.insertTransaction(t);
    await loadTransactions();
  }

  Future updateTransaction(CashTransaction t) async {
    await _db.updateTransaction(t);
    await loadTransactions();
  }
  Future deleteTransaction(int id) async {
    await _db.deleteTransaction(id);
    await loadTransactions();
  }
  Future<double> getBalance() async {
    return await _db.getBalance();
  }
}