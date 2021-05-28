import 'package:expend_tracker/cons/app_color.dart';
import 'package:expend_tracker/cons/enum.dart';
import 'package:expend_tracker/cons/extension.dart';
import 'package:expend_tracker/model/category_model.dart';
import 'package:expend_tracker/model/transaction_model.dart';
import 'package:expend_tracker/screen/category_screen.dart';
import 'package:expend_tracker/utils/app_db.dart';
import 'package:expend_tracker/utils/masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddExpenseScreen extends StatefulWidget {
  AddExpenseScreen({Key? key, required this.transactionType, this.transactionModel}) : super(key: key);
  final TransactionType transactionType;
  final TransactionModel? transactionModel;

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  DBHelper db = DBHelper();

  // final TextEditingController amountCtrl = TextEditingController();
  final TextEditingController noteCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController categoryCtrl = TextEditingController();
  final amountCtrl = MoneyMaskedTextController(
    decimalSeparator: '',
    thousandSeparator: ',',
    initialValue: 0.0,
    precision: 0,
    leftSymbol: 'Rp. ',
  );

  @override
  void initState() {
    if (widget.transactionModel != null) {
      noteCtrl.text = widget.transactionModel?.note ?? '';
      amountCtrl.text = widget.transactionModel?.amount.toInt().toString() ?? '';
      categoryCtrl.text = widget.transactionModel?.categoryModel?.id.toString() ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${widget.transactionType.getName()}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FutureBuilder<List<CategoryModel>>(
                          future: db.getCategory(widget.transactionType),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return DropdownButtonFormField(
                                value: categoryCtrl.text.isNotEmpty ? categoryCtrl.text : null,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please choose category';
                                  }
                                  return null;
                                },
                                // autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  labelText: 'Type',
                                  hintText: 'What Expense?',
                                ),
                                onChanged: (val) {
                                  categoryCtrl.text = val.toString();
                                },
                                items: (snapshot.data ?? [])
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e.id.toString(),
                                        child: Row(
                                          children: [
                                            Icon(e.icon),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(e.name),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            }
                            if (snapshot.hasError) {
                              print(snapshot.stackTrace);
                              return Center(
                                child: Text('${snapshot.error.toString()}'),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ManageCategoryScreen(
                              transactionType: widget.transactionType,
                            ),
                          ),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please fill the amount';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                      ),
                      labelText: 'Amount',
                      hintText: 'How much?'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: noteCtrl,
                  maxLines: null,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                      ),
                      labelText: 'Note',
                      hintText: 'Add note'),
                ),
                SizedBox(
                  height: 20,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 100,
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (widget.transactionModel != null) {
                          await db.editTransaction(
                            id: widget.transactionModel!.id,
                            amount: amountCtrl.numberValue,
                            categoryId: int.parse(categoryCtrl.text),
                            transactionType: widget.transactionType,
                            note: noteCtrl.text,
                          );
                        } else {
                          await db.insertTransaction(
                              amount: amountCtrl.numberValue,
                              categoryId: int.parse(categoryCtrl.text),
                              transactionType: widget.transactionType,
                              note: noteCtrl.text);
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
