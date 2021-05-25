import 'package:expend_tracker/cons/app_color.dart';
import 'package:flutter/material.dart';

class AddIncomeScreen extends StatefulWidget {
  AddIncomeScreen({Key? key}) : super(key: key);

  @override
  _AddIncomeScreenState createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
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
                    onPressed: () {},
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
                    style: TextStyle(
                      fontSize: 16,
                    ),
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
