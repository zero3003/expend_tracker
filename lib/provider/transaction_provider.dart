import 'package:expend_tracker/cons/enum.dart';
import 'package:expend_tracker/model/transaction_model.dart';
import 'package:expend_tracker/utils/app_db.dart';
import 'package:flutter/foundation.dart';

class TransactionProvider extends ChangeNotifier {
  DBHelper db = DBHelper();
  List<TransactionModel> listExpense = [];
  List<TransactionModel> listIncome = [];
  List<TransactionModel> listAll = [];

  LoadState state = LoadState.Loading;

  Future getTransaction() async {
    listExpense = await db.getTransaction(TransactionType.Expense);
    notifyListeners();
  }

  Future getIncome() async {
    listExpense = await db.getTransaction(TransactionType.Income);
    notifyListeners();
  }
}
