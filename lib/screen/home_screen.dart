import 'package:expend_tracker/cons/app_color.dart';
import 'package:expend_tracker/cons/app_cons.dart';
import 'package:expend_tracker/cons/enum.dart';
import 'package:expend_tracker/cons/extension.dart';
import 'package:expend_tracker/model/transaction_model.dart';
import 'package:expend_tracker/screen/add_transaction_screen.dart';
import 'package:expend_tracker/screen/transaction_screen.dart';
import 'package:expend_tracker/utils/app_db.dart';
import 'package:expend_tracker/widget/card_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper db = DBHelper();

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense Tracker',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.reset_tv),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Reset Database'),
                      content: Text('You wil lose all your record.'),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await db.deleteDB();
                            await db.initDB();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(elevation: 0, primary: Colors.redAccent),
                          child: Text('Reset'),
                        ),
                      ],
                    );
                  }).then((value) => refresh());
            },
            splashRadius: 24,
          ),
          IconButton(
            icon: Icon(Icons.category),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Setting Category'),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ManageCategoryScreen(transactionType: TransactionType.Expense),
                                ),
                              );
                            },
                            child: Text('Expense'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ManageCategoryScreen(transactionType: TransactionType.Income),
                                ),
                              );
                            },
                            child: Text('Income'),
                          ),
                        ],
                      ),
                    );
                  }).then((value) => refresh());
            },
            splashRadius: 24,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<double>>(
                future: db.getStats(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        Expanded(
                          child: CardInfo(
                            label: 'My Budget',
                            count: '${snapshot.data![0].toRupiah()}',
                            color: primaryColor,
                            bottomText: 'Income History',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TransactionScreen(transactionType: TransactionType.Income),
                                ),
                              ).then((value) => refresh());
                            },
                          ),
                        ),
                        Expanded(
                          child: CardInfo(
                            label: 'My Expenses',
                            count: '${snapshot.data![1].toRupiah()}',
                            color: redColor,
                            bottomText: 'Expense History',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TransactionScreen(transactionType: TransactionType.Expense),
                                ),
                              ).then((value) => refresh());
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error.toString()}'),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                }),
            Divider(
              color: primaryColor,
              height: 34,
            ),
            Text(
              'Transaction History',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: FutureBuilder<List<TransactionModel>>(
                  future: db.getAllTransaction(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data?.length != 0
                          ? ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, idx) {
                                TransactionModel tr = snapshot.data![idx];
                                return ListTile(
                                  leading: Icon(tr.categoryModel?.icon),
                                  title: Text('${tr.amount.toRupiah()}'),
                                  subtitle: Text('${tr.categoryModel?.name} - ${tr.note ?? ''}'),
                                  trailing: tr.transactionType == TransactionType.Expense ? iconUp : iconDown,
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
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        // animatedIcon: AnimatedIcons.menu_close,
        // animatedIconTheme: IconThemeData(size: 22.0),

        /// This is ignored if animatedIcon is non null
        icon: Icons.add,
        activeIcon: Icons.close,
        // iconTheme: IconThemeData(color: Colors.grey[50], size: 30),
        /// The label of the main button.
        // label: Text("Open Speed Dial"),
        /// The active label of the main button, Defaults to label if not specified.
        // activeLabel: Text("Close Speed Dial"),
        /// Transition Builder between label and activeLabel, defaults to FadeTransition.
        // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
        /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
        buttonSize: 56.0,
        visible: true,

        /// If true user is forced to close dial manually
        /// by tapping main button and overlay is not rendered.
        closeManually: false,

        /// If true overlay will render no matter what.
        renderOverlay: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.0,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        // orientation: SpeedDialOrientation.Up,
        // childMarginBottom: 2,
        // childMarginTop: 2,
        children: [
          SpeedDialChild(
            child: Icon(
              Icons.add_shopping_cart,
              color: Colors.white,
            ),
            backgroundColor: redColor,
            label: 'Add Expense',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (_) => AddExpenseScreen(
                        transactionType: TransactionType.Expense,
                      ),
                    ),
                  )
                  .then((value) => refresh());
            },
          ),
          SpeedDialChild(
            child: Icon(
              Icons.widgets_outlined,
              color: Colors.white,
            ),
            backgroundColor: greenColor,
            label: 'Add Income',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (_) => AddExpenseScreen(
                        transactionType: TransactionType.Income,
                      ),
                    ),
                  )
                  .then((value) => refresh());
            },
          ),
        ],
      ),
    );
  }
}
