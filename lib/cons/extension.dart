import 'package:intl/intl.dart';

extension numberFormat on double {
  String toRupiah() => '${NumberFormat.currency(locale: 'in', decimalDigits: 0, symbol: 'Rp. ').format(this)}';
}
