import 'package:flutter/material.dart';
import 'package:sql_todolist_1/models/category.dart';
import 'package:sql_todolist_1/screens/home_screen.dart';
import 'package:sql_todolist_1/services/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();

  List<Category> _categoryList = [];

  var category;
  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    _categoryList = [];
    var categories = await _categoryService.readCategories();
    categories.forEach(
      (category) {
        setState(
          () {
            var categoryModel = Category();
            categoryModel.id = category['id'];
            categoryModel.name = category['name'];
            categoryModel.description = category['description'];
            _categoryList.add(categoryModel);
          },
        );
      },
    );
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(
      () {
        _editCategoryNameController.text = category[0]['name'] ?? 'No name';
        _editCategoryDescriptionController.text =
            category[0]['description'] ?? 'No description';
      },
    );
    _editFormDialog(context);
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              TextButton(
                style: TextButton.styleFrom(primary: Colors.red),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(primary: Colors.blue),
                onPressed: () async {
                  _category.name = _categoryNameController.text;
                  _category.description = _categoryDescriptionController.text;

                  var result = await _categoryService.saveCategory(_category);
                  getAllCategories();
                  print(result);
                  Navigator.pop(context);
                },
                child: Text('Save'),
              )
            ],
            title: Text('Categories Form'),
            content: SingleChildScrollView(
              child: Column(children: [
                TextField(
                  controller: _categoryNameController,
                  decoration: InputDecoration(
                    hintText: 'Write a category',
                    labelText: 'Category',
                  ),
                ),
                TextField(
                  controller: _categoryDescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Write a description',
                    labelText: 'Description',
                  ),
                ),
              ]),
            ),
          );
        });
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              TextButton(
                style: TextButton.styleFrom(primary: Colors.red),
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(primary: Colors.blue),
                onPressed: () async {
                  _category.id = category[0]['id'];
                  _category.name = _editCategoryNameController.text;
                  _category.description =
                      _editCategoryDescriptionController.text;

                  var result = await _categoryService.updateCategory(_category);
                  getAllCategories();
                  print(result);
                },
                child: Text('Update'),
              ),
            ],
            title: Text('Edit Categories Form'),
            content: SingleChildScrollView(
              child: Column(children: [
                TextField(
                  controller: _editCategoryNameController,
                  decoration: InputDecoration(
                    hintText: 'Write a category',
                    labelText: 'Category',
                  ),
                ),
                TextField(
                  controller: _editCategoryDescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Write a description',
                    labelText: 'Description',
                  ),
                ),
              ]),
            ),
          );
        });
  }

  _deleteFormDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              TextButton(
                style: TextButton.styleFrom(primary: Colors.green),
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(primary: Colors.red),
                onPressed: () async {
                  var result = await _categoryService.deleteCategory(categoryId);
                  getAllCategories();
                  print(result);
                  Navigator.pop(context);
                  //Navigator.pop(context);
                },
                child: Text('Delete'),
              ),
            ],
            title: Text('Are you sure you want to delete this?'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen())),
          child: Icon(Icons.arrow_back, color: Colors.white),
          style: ElevatedButton.styleFrom(primary: Colors.blue),
        ),
        title: Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: _categoryList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Card(
              elevation: 8.0,
              child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editCategory(context, _categoryList[index].id);
                    },
                  ),
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_categoryList[index].name),
                        IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _deleteFormDialog(context, _categoryList[index].id);
                            }),
                      ]),
                  subtitle: Text(_categoryList[index].description)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
