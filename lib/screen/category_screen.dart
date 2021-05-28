import 'package:expend_tracker/cons/enum.dart';
import 'package:expend_tracker/model/category_model.dart';
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
  DBHelper db = DBHelper();

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
                    setState(() {});
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
              child: FutureBuilder<List<CategoryModel>>(
                  future: db.getCategory(widget.transactionType),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, idx) {
                          CategoryModel category = snapshot.data![idx];
                          return Card(
                            child: ListTile(
                              leading: Icon(category.icon),
                              title: Text('${category.name}'),
                              trailing: PopupMenuButton<int>(
                                icon: Icon(Icons.menu),
                                onSelected: (num) async {
                                  if (num == 1) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AddCategoryDialog(
                                            initialIcon: category.icon,
                                            initialText: category.name,
                                            onSave: (text, icon) async {
                                              DBHelper db = DBHelper();
                                              await db.editCategory(
                                                id: category.id,
                                                name: text,
                                                icon: icon,
                                                transactionType: widget.transactionType,
                                              );
                                              setState(() {});
                                            },
                                          );
                                        });
                                  } else if (num == 2) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Delete Category'),
                                            actions: [
                                              OutlinedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await db.deleteCategory(
                                                      id: category.id, transactionType: widget.transactionType);
                                                  Navigator.pop(context);
                                                },
                                                style:
                                                    ElevatedButton.styleFrom(elevation: 0, primary: Colors.redAccent),
                                                child: Text('Delete'),
                                              ),
                                            ],
                                          );
                                        }).then((value) {
                                      setState(() {});
                                    });
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
                            ),
                          );
                        },
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
          ],
        ),
      ),
    );
  }
}
