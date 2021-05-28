import 'package:expend_tracker/cons/enum.dart';
import 'package:intl/intl.dart';

extension numberFormat on double {
  String toRupiah() => '${NumberFormat.currency(locale: 'in', decimalDigits: 0, symbol: 'Rp. ').format(this)}';
}

extension typeTrans on TransactionType {
  String getName() {
    switch (this) {
      case TransactionType.Expense:
        return 'Expense';
      case TransactionType.Income:
        return 'Income';
    }
  }
}
