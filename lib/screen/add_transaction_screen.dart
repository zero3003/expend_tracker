import 'package:expend_tracker/cons/app_color.dart';
import 'package:expend_tracker/cons/enum.dart';
import 'package:expend_tracker/model/category_model.dart';
import 'package:expend_tracker/screen/category_screen.dart';
import 'package:expend_tracker/utils/app_db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddExpenseScreen extends StatefulWidget {
  AddExpenseScreen({Key? key, required this.transactionType}) : super(key: key);
  final TransactionType transactionType;

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  DBHelper db = DBHelper();

  final TextEditingController amountCtrl = TextEditingController();
  final TextEditingController noteCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController categoryCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn UI'),
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                        await db.insertTransaction(
                            amount: amountCtrl.text,
                            categoryId: int.parse(categoryCtrl.text),
                            transactionType: widget.transactionType,
                            note: noteCtrl.text);
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
