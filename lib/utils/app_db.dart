import 'dart:convert';

import 'package:expend_tracker/cons/enum.dart';
import 'package:expend_tracker/model/category_model.dart';
import 'package:expend_tracker/model/transaction_model.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String DB_NAME = "expense_tracker.db";
  static const String EXPENSE_TABLE = "expense";
  static const String INCOME_TABLE = "income";
  static const String EXPENSE_CATEGORY_TABLE = "expense_category";
  static const String INCOME_CATEGORY_TABLE = "income_category";

  Future deleteDB() async {
    await deleteDatabase(join(await getDatabasesPath(), '$DB_NAME'));
  }

  Future<Database> initDB() async {
    return openDatabase(
      join(await getDatabasesPath(), '$DB_NAME'),
      // When the database is first created, create a table to store dogs.
      onConfigure: (db) async {
        // Enable Foreign Key
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
          'CREATE TABLE $EXPENSE_CATEGORY_TABLE(id INTEGER PRIMARY KEY, name TEXT, icon TEXT,'
          'created_at STRING, updated_at STRING, deleted_at STRING)',
        );
        await db.execute(
          'CREATE TABLE $INCOME_CATEGORY_TABLE(id INTEGER PRIMARY KEY, name TEXT, icon TEXT,'
          'created_at STRING, updated_at STRING, deleted_at STRING)',
        );
        await db.execute(
          'CREATE TABLE $EXPENSE_TABLE('
          'id INTEGER PRIMARY KEY, '
          'name TEXT, amount DOUBLE, category_id INTEGER, note TEXT,'
          'created_at STRING, updated_at STRING, deleted_at STRING,'
          'FOREIGN KEY (category_id) REFERENCES $EXPENSE_CATEGORY_TABLE (id) ON DELETE NO ACTION ON UPDATE NO ACTION)',
        );
        await db.execute(
          'CREATE TABLE $INCOME_TABLE('
          'id INTEGER PRIMARY KEY, '
          'name TEXT, amount DOUBLE, category_id INTEGER, note TEXT,'
          'created_at STRING, updated_at STRING, deleted_at STRING,'
          'FOREIGN KEY (category_id) REFERENCES $INCOME_CATEGORY_TABLE (id) ON DELETE NO ACTION ON UPDATE NO ACTION)',
        );

        await db.insert('$INCOME_CATEGORY_TABLE', {
          'name': 'Salary',
          'created_at': DateTime.now().toIso8601String(),
        });
        await db.insert('$INCOME_CATEGORY_TABLE', {
          'name': 'Gift',
          'created_at': DateTime.now().toIso8601String(),
        });
        await db.insert('$EXPENSE_CATEGORY_TABLE', {
          'name': 'Transportation',
          'created_at': DateTime.now().toIso8601String(),
        });
        await db.insert('$EXPENSE_CATEGORY_TABLE', {
          'name': 'Internet Charge',
          'created_at': DateTime.now().toIso8601String(),
        });
        return;
      },
      version: 1,
    );
  }

  Future insertTransaction({
    required String name,
    required String amount,
    required int categoryId,
    required TransactionType transactionType,
    String? note,
  }) async {
    Database db = await initDB();
    String table;
    switch (transactionType) {
      case TransactionType.Expense:
        table = EXPENSE_TABLE;
        break;
      case TransactionType.Income:
        table = INCOME_TABLE;
        break;
    }
    await db.insert('$table', {
      'name': name,
      'amount': double.parse(amount),
      'category_id': categoryId,
      'note': note,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future editTransaction({
    required String id,
    required String name,
    required String amount,
    required int categoryId,
    required TransactionType transactionType,
    String? note,
  }) async {
    Database db = await initDB();
    String table;
    switch (transactionType) {
      case TransactionType.Expense:
        table = EXPENSE_TABLE;
        break;
      case TransactionType.Income:
        table = INCOME_TABLE;
        break;
    }
    await db.update(
        '$table',
        {
          'name': name,
          'amount': double.parse(amount),
          'category_id': categoryId,
          'note': note,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id]);
  }

  Future deleteTransaction({
    required String id,
    required TransactionType transactionType,
  }) async {
    Database db = await initDB();
    String table;
    switch (transactionType) {
      case TransactionType.Expense:
        table = EXPENSE_TABLE;
        break;
      case TransactionType.Income:
        table = INCOME_TABLE;
        break;
    }
    await db.delete('$table', where: 'id = ?', whereArgs: [id]);
  }

  Future insertCategory({
    required String name,
    required String icon,
    required TransactionType transactionType,
  }) async {
    Database db = await initDB();
    String table;
    switch (transactionType) {
      case TransactionType.Expense:
        table = EXPENSE_CATEGORY_TABLE;
        break;
      case TransactionType.Income:
        table = INCOME_CATEGORY_TABLE;
        break;
    }
    await db.insert('$table', {
      'name': name,
      'icon': icon,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future editCategory({
    required String id,
    required String name,
    required String icon,
    required TransactionType transactionType,
  }) async {
    Database db = await initDB();
    String table;
    switch (transactionType) {
      case TransactionType.Expense:
        table = EXPENSE_CATEGORY_TABLE;
        break;
      case TransactionType.Income:
        table = INCOME_CATEGORY_TABLE;
        break;
    }
    await db.update(
        '$table',
        {
          'name': name,
          'icon': icon,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id]);
  }

  Future deleteCategory({
    required String id,
    required TransactionType transactionType,
  }) async {
    Database db = await initDB();
    String table;
    switch (transactionType) {
      case TransactionType.Expense:
        table = EXPENSE_CATEGORY_TABLE;
        break;
      case TransactionType.Income:
        table = INCOME_CATEGORY_TABLE;
        break;
    }
    await db.delete('$table', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<TransactionModel>> getTransaction(TransactionType type) async {
    Database db = await initDB();
    String table;
    String tableCategory;
    switch (type) {
      case TransactionType.Expense:
        table = EXPENSE_TABLE;
        tableCategory = EXPENSE_CATEGORY_TABLE;
        break;
      case TransactionType.Income:
        table = INCOME_TABLE;
        tableCategory = INCOME_CATEGORY_TABLE;
        break;
    }
    // final List<Map<String, dynamic>> maps = await db.query('$table');
    final List<Map<String, dynamic>> maps = await db.rawQuery(""
        "SELECT $table.*,"
        "$tableCategory.name as category_name, $tableCategory.icon as category_icon "
        "FROM $table INNER JOIN $tableCategory "
        "WHERE $table.category_id == $tableCategory.id");
    print(type);
    print(maps.toString());
    return List.generate(maps.length, (i) {
      return TransactionModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        amount: maps[i]['amount'],
        categoryModel: CategoryModel(
          id: maps[i]['category_id'],
          name: maps[i]['category_name'],
          icon: deserializeIcon(jsonDecode('${(maps[i]['category_icon'])}'))!,
          transactionType: type,
        ),
        note: maps[i]['note'],
        transactionType: type,
        createdAt: DateTime.parse(maps[i]['created_at']),
      );
    });
  }

  Future<List<TransactionModel>> getAllTransaction() async {
    List<TransactionModel> expense = await getTransaction(TransactionType.Expense);
    List<TransactionModel> income = await getTransaction(TransactionType.Income);

    List<TransactionModel> trans = List<TransactionModel>.from(expense)..addAll(income);
    trans.sort((a, b) {
      return a.createdAt.compareTo(b.createdAt);
    });
    return trans;
  }

  Future<List<CategoryModel>> getCategory(TransactionType type) async {
    Database db = await initDB();
    String table;
    switch (type) {
      case TransactionType.Expense:
        table = EXPENSE_CATEGORY_TABLE;
        break;
      case TransactionType.Income:
        table = INCOME_CATEGORY_TABLE;
        break;
    }
    final List<Map<String, dynamic>> maps = await db.query('$table');

    return List.generate(maps.length, (i) {
      return CategoryModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        transactionType: type,
        icon: maps[i]['icon'],
      );
    });
  }
}
