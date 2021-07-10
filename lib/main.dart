import 'package:employeeapp/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    EmployeeApp(),
  );
}

class EmployeeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Details',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
