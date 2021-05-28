import 'package:expend_tracker/cons/enum.dart';
import 'package:expend_tracker/model/category_model.dart';

class TransactionModel {
  int id;
  String? note;
  double amount;
  CategoryModel? categoryModel;
  DateTime createdAt;
  TransactionType transactionType;

  TransactionModel({
    required this.id,
    this.categoryModel,
    required this.amount,
    this.note,
    required this.transactionType,
    required this.createdAt,
  });
}
