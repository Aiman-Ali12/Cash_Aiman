import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../models/transaction_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "cashbook.db");

    return await openDatabase(
      path,
      version: 2, // زودنا الرقم عشان نضيف جدول users
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    // جدول المعاملات
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL,
        date TEXT,
        type TEXT,
        note TEXT
      )
    ''');

    // جدول المستخدمين
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');

    print("Database created with tables transactions & users");
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT UNIQUE,
          password TEXT
        )
      ''');
      print("Users table added on upgrade");
    }
  }

  // ================= Users =================
  Future<int> insertUser(String username, String password) async {
    final dbClient = await db;
    try {
      int id = await dbClient.insert('users', {
        'username': username.trim().toLowerCase(),
        'password': password.trim(),
      });
      print("User inserted: $username");
      return id;
    } catch (e) {
      print("Error inserting user: $e");
      rethrow;
    }
  }

  Future<bool> loginUser(String username, String password) async {
    final dbClient = await db;
    final res = await dbClient.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username.trim().toLowerCase(), password.trim()],
    );
    print("Login query result: $res");
    return res.isNotEmpty;
  }

  // ================= Transactions =================
  Future<int> insertTransaction(CashTransaction t) async {
    final dbClient = await db;
    return await dbClient.insert('transactions', t.toMap());
  }

  Future<List<CashTransaction>> getAllTransactions() async {
    final dbClient = await db;
    final res = await dbClient.query('transactions', orderBy: 'date DESC');
    return res.map((e) => CashTransaction.fromMap(e)).toList();
  }

  Future<int> updateTransaction(CashTransaction t) async {
    final dbClient = await db;
    return await dbClient.update('transactions', t.toMap(),
        where: 'id = ?', whereArgs: [t.id]);
  }

  Future<int> deleteTransaction(int id) async {
    final dbClient = await db;
    return await dbClient.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getBalance() async {
    final dbClient = await db;
    final incomeRes =
    await dbClient.rawQuery('SELECT SUM(amount) as total FROM transactions WHERE type = ?', ['income']);
    final expenseRes =
    await dbClient.rawQuery('SELECT SUM(amount) as total FROM transactions WHERE type = ?', ['expense']);
    double inc = (incomeRes.first['total'] as num?)?.toDouble() ?? 0.0;
    double exp = (expenseRes.first['total'] as num?)?.toDouble() ?? 0.0;
    return inc - exp;
  }
}
