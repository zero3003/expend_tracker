import 'package:expend_tracker/cons/enum.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  int id;
  String name;
  IconData icon;
  TransactionType transactionType;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.transactionType,
  });
}
