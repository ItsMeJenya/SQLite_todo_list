import 'package:flutter/material.dart';
import 'package:sql_todolist_1/screens/categories_screen.dart';
import 'package:sql_todolist_1/screens/home_screen.dart';
import 'package:sql_todolist_1/services/category_service.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  List<Widget> _categoryList = [];
  CategoryService _categoryService = CategoryService();

  getAllCategories() async {
    var categories = await _categoryService.readCategories();
    categories.forEach(
      (category) {
        setState(
          () {
            _categoryList.add(ListTile(
              title: Text(category['name']),
            ));
          },
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    getAllCategories();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Eugene'),
              accountEmail: Text('myemail@gmail.com'),
              decoration: BoxDecoration(color: Colors.amber),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen())),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Categories'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CategoriesScreen())),
            ),
            Divider(),
            Column(
              children:
                _categoryList
              ,
            )
          ],
        ),
      ),
    );
  }
}
