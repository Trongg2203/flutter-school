import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  await initializeDateFormatting('vi_VN', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: ExpenseTrackerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
