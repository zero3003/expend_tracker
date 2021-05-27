import 'package:expend_tracker/screen/home_screen.dart';
import 'package:expend_tracker/utils/app_db.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => MyApp(), // Wrap your app
  //   ),
  // );
  DBHelper db = DBHelper();
  // await db.deleteDB();
  await db.initDB();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'ComicNeue',
      ),
      home: HomeScreen(),
    );
  }
}
