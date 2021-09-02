import 'package:flutter/material.dart';
import 'package:sql_todolist_1/screens/categories_screen.dart';
import 'package:sql_todolist_1/screens/home_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
      HomeScreen(),
      //CategoriesScreen(),
    );
  }
}
