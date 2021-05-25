import 'package:expend_tracker/cons/app_color.dart';
import 'package:expend_tracker/screen/category_screen.dart';
import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  AddExpenseScreen({Key? key}) : super(key: key);

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn UI'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
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
                      onChanged: (val) {},
                      items: ['Transport', 'Home']
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                    ),
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
                          builder: (_) => ManageCategoryScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
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
                  onPressed: () {},
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
    );
  }
}
