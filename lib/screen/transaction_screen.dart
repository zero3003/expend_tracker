import 'package:expend_tracker/cons/enum.dart';
import 'package:expend_tracker/cons/extension.dart';
import 'package:expend_tracker/model/transaction_model.dart';
import 'package:expend_tracker/utils/app_db.dart';
import 'package:flutter/material.dart';

import 'add_transaction_screen.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key, required this.transactionType}) : super(key: key);
  final TransactionType transactionType;

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  DBHelper db = DBHelper();

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.transactionType.getName()} History'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => AddExpenseScreen(
                    transactionType: widget.transactionType,
                  ),
                ),
              )
              .then((value) => refresh());
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<TransactionModel>>(
          future: db.getTransaction(widget.transactionType),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data?.length != 0
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, idx) {
                        TransactionModel tr = snapshot.data![idx];
                        return ListTile(
                          leading: Icon(tr.categoryModel?.icon),
                          title: Text('${tr.amount.toRupiah()}'),
                          subtitle: Text('${tr.categoryModel?.name} - ${tr.note ?? ''}'),
                          trailing: PopupMenuButton<int>(
                            icon: Icon(Icons.menu),
                            onSelected: (num) async {
                              if (num == 1) {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (_) => AddExpenseScreen(
                                          transactionType: widget.transactionType,
                                          transactionModel: tr,
                                        ),
                                      ),
                                    )
                                    .then((value) => refresh());
                              } else if (num == 2) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Delete Transaction'),
                                        actions: [
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await db.deleteTransaction(
                                                  id: tr.id, transactionType: widget.transactionType);
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(elevation: 0, primary: Colors.redAccent),
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      );
                                    }).then((value) => refresh());
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text(
                                  "Edit",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(
                                  "Delete",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text('No Transaction Recorded'),
                    );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error.toString()}'),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
