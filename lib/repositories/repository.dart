import 'package:sqflite/sqflite.dart';
import 'package:sql_todolist_1/repositories/database_connection.dart';

class Repository {
  DatabaseConnection _databaseConnection;

  Repository() {
    // Initialize database connection
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  //Check if database is exist or not
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }

  // Inserting data to Table
  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  //Read data from Table
  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

//Read data from table by id
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection.query(table, where: 'id=?', whereArgs: [itemId]);
  }

//update data from table
  updateData(table, data) async {
    var connection = await database;
    return await connection
        .update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

//delete data from table by id
  deleteData(table, itemId) async {
    var connection = await database;
    return await connection.rawDelete("DELETE FROM $table WHERE id = $itemId");
  }

  //read data from table by column Name
  readDataByColumnName(table, columnName, columnValue) async {
    var connection = await database;
    return await connection.query(table, where: '$columnName=?', whereArgs: [columnValue]);
  }
}
