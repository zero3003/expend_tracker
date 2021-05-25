import 'package:expend_tracker/cons/app_color.dart';
import 'package:flutter/material.dart';

class CardMenu extends StatelessWidget {
  const CardMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: redColor, width: 1.0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Lihat Pendapatan'),
        ),
      ),
    );
  }
}
