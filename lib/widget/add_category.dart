import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({
    Key? key,
    required this.onSave,
  }) : super(key: key);
  final Function(String, String) onSave;
  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  IconData? iconData;
  TextEditingController name = TextEditingController();

  @override
  void initState() {
    iconData = Icons.add_shopping_cart;
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
                    title: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, IconPack.material);
                      },
                      child: Text(
                        'Pick an Icon',
                        style: TextStyle(fontFamily: 'ComicNeue'),
                      ),
                    ),
                  );
                  if (icon != null) {
                    setState(() {
                      iconData = IconData(
                        icon.codePoint,
                        fontFamily: icon.fontFamily,
                        fontPackage: icon.fontPackage,
                      );
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
            await widget.onSave(name.text, serializeIcon(iconData!).toString());
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(elevation: 0),
          child: Text('Save'),
        ),
      ],
    );
  }
}
