import 'package:flutter/material.dart';

class ManageCategoryScreen extends StatefulWidget {
  const ManageCategoryScreen({Key? key}) : super(key: key);

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
                return AlertDialog(
                  title: Text('Add Category'),
                  content: TextField(),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(elevation: 0),
                      child: Text('Save'),
                    ),
                  ],
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
