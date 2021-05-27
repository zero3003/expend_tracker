import 'package:expend_tracker/cons/enum.dart';
import 'package:expend_tracker/utils/app_db.dart';
import 'package:expend_tracker/widget/add_category.dart';
import 'package:flutter/material.dart';

class ManageCategoryScreen extends StatefulWidget {
  const ManageCategoryScreen({Key? key, required this.transactionType}) : super(key: key);
  final TransactionType transactionType;
  @override
  _ManageCategoryScreenState createState() => _ManageCategoryScreenState();
}

class _ManageCategoryScreenState extends State<ManageCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn UI'),
      ),
      // floatingActionButton: TextFieldFloatingActionButton(
      //   'Search...',
      //   Icons.add,
      //   onChange: (String query) {
      //     print('$query');
      //   },
      //   onClear: () {},
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AddCategoryDialog(
                  onSave: (text, icon) async {
                    DBHelper db = DBHelper();
                    await db.insertCategory(
                      name: text,
                      icon: icon,
                      transactionType: widget.transactionType,
                    );
                  },
                );
              });
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, idx) {
                  return Card(
                    child: InkWell(
                      onTap: () {},
                      child: ListTile(
                        leading: Icon(Icons.transfer_within_a_station_sharp),
                        title: Text('Transportation'),
                        trailing: PopupMenuButton<int>(
                          icon: Icon(Icons.menu),
                          onSelected: (num) {
                            if (num == 1) {}
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
                              value: 1,
                              child: Text(
                                "Hapus",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
