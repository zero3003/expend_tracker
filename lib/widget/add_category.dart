import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({
    Key? key,
    required this.onSave,
    this.initialText,
    this.initialIcon,
  }) : super(key: key);
  final Function(String, String) onSave;
  final String? initialText;
  final IconData? initialIcon;

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  IconData? iconData;
  TextEditingController name = TextEditingController();

  @override
  void initState() {
    iconData = widget.initialIcon ?? Icons.add_shopping_cart;
    name.text = widget.initialText ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            decoration: InputDecoration(
              hintText: 'Category Name',
            ),
            onChanged: (val) {},
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Icon : ',
                  ),
                  Icon(iconData),
                ],
              ),
              TextButton(
                onPressed: () async {
                  IconData? icon = await FlutterIconPicker.showIconPicker(
                    context,
                    iconPackMode: IconPack.fontAwesomeIcons,
                    iconSize: 32,
                  );
                  if (icon != null) {
                    setState(() {
                      iconData = icon;
                    });
                  }
                },
                child: Text('Change Icon'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await widget.onSave(name.text, jsonEncode(serializeIcon(iconData!)));
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(elevation: 0),
          child: Text('Save'),
        ),
      ],
    );
  }
}
