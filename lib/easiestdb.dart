/*
MIT License

Copyright (c) 2020 Fayaz Bin Salam

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EasiestDb {
  // Vars
  static String _dbName;
  static int _version = 1;
  static String _dbPath;
  static List<DbTable> _tables = [];
  static Database _db;

  // deleteDatabase --- The function name explains everything though
  static void deleteDatabase() {
    String sql = ' DROP DATABASE ${_dbName.replaceAll(".db", "")} ';
    _db.execute(sql);
  }

  // deleteTable --- The function name explains everything though
  static void deleteTable(int tableIndex) {
    String sql = ' DROP TABLE ${_tables[tableIndex]._tableName} ';
    _db.execute(sql);
  }

  // deleteDataBySearchingInColumn --- The function name explains everything though
  static Future<int> deleteDataBySearchingInColumn(
      int tableIndex, Datum datum) {
    String sql =
        ' DELETE FROM ${_tables[tableIndex]._tableName} WHERE ${_tables[tableIndex]._dbColumns[datum._columnIndex]._columnName} = ${datum._value} ';
    return _db.rawDelete(sql);
  }

  // deleteOneData --- The function name explains everything though
  static Future<int> deleteOneData(int tableIndex, int rowId) {
    String sql =
        ' DELETE FROM ${_tables[tableIndex]._tableName} WHERE ID = $rowId ';
    return _db.rawDelete(sql);
  }

  // updateOneDataById --- The function name explains everything though
  static Future<int> updateOneDataById(
      int tableIndex, int rowId, List<Datum> data) {
    //
    String sql = ' UPDATE ${_tables[tableIndex]._tableName} SET ';
    List<DbColumn> columns = _tables[tableIndex]._dbColumns;

    for (int i = 0; i < data.length; i++) {
      sql +=
          " ${columns[data[i]._columnIndex]._columnName} = \'${data[i]._value}\' ";
      if (i == data.length - 1) {
        sql += " ";
      } else {
        sql += " , ";
      }
    }

    sql += " WHERE ID = $rowId ";

    return _db.rawUpdate(sql);
  }

  // getRowsByMatchingColumnData --- The function name explains everything though
  static Future<List<Map<String, dynamic>>> getRowsByMatchingColumnData(
      int tableIndex, int columnIndex, var valueToMatch,
      {bool ascending = true}) {
    //
    String orderBy = ascending ? "ASC" : "DESC";
    String sql =
        ' SELECT * FROM ${_tables[tableIndex]._tableName} WHERE ${_tables[tableIndex]._dbColumns[columnIndex]._columnName}=$valueToMatch ORDER BY ID $orderBy ';
    return _db.rawQuery(sql);
  }

  // getOneRowData --- The function name explains everything though
  static Future<List<Map<String, dynamic>>> getOneRowData(
      int tableIndex, int rowId) {
    //
    String sql =
        ' SELECT * FROM ${_tables[tableIndex]._tableName} WHERE ID=$rowId ';
    return _db.rawQuery(sql);
  }

  // getAllData --- The function name explains everything though
  static Future<List<Map<String, dynamic>>> getAllData(int tableIndex,
      {bool ascending = true}) {
    //
    String orderBy = ascending ? "ASC" : "DESC";
    String sql =
        ' SELECT * FROM ${_tables[tableIndex]._tableName} ORDER BY ID $orderBy ';
    return _db.rawQuery(sql);
  }

  // addData --- The function name explains everything though
  static Future<int> addData(int tableIndex, List<Datum> data) {
    //
    String sql = ' INSERT INTO ${_tables[tableIndex]._tableName} ( ';
    List<DbColumn> columns = _tables[tableIndex]._dbColumns;

    for (int i = 0; i < data.length; i++) {
      sql += " " + columns[data[i]._columnIndex]._columnName + " ";

      if (i == data.length - 1) {
        sql += " ) ";
      } else {
        sql += " , ";
      }
    }

    sql += " VALUES ( ";

    for (int i = 0; i < data.length; i++) {
      sql += " \'" + data[i]._value + "\' ";

      if (i == data.length - 1) {
        sql += " ) ";
      } else {
        sql += " , ";
      }
    }

    return _db.rawInsert(sql);
  }

  // init --- The function name explains everything though
  static Future<Database> init({
    String dbName = 'demo.db',
    int version = 1,
    List<DbTable> tables,
  }) async {
    //
    _tables = tables;
    _dbPath = await getDatabasesPath();
    _dbName = dbName.replaceAll(" ", "_").toUpperCase();
    if (!_dbName.endsWith(".db")) {
      _dbName += ".db";
    }
    _version = version;

    print("Creating database");

    return _db = await openDatabase(join(_dbPath, _dbName),
        onCreate: (db, version) {
          print("onCreate");
          for (int i = 0; i < tables.length; i++) {
            String sql = " CREATE TABLE " + tables[i]._tableName + " ( ";

            List<DbColumn> columns = tables[i]._dbColumns;

            for (int j = 0; j < columns.length; j++) {
              sql += " " +
                  columns[j]._columnName +
                  " " +
                  columns[j]._columnDataType +
                  " ";

              if (j == columns.length - 1) {
                sql += " ) ";
              } else {
                sql += " , ";
              }
            }

            db.execute(sql);
            print("$_dbName creatd");
          }
        },
        version: _version,
        onConfigure: (Database db) {
          print("onConfigure");
        },
        onOpen: (Database db) {
          print("onOpen");
        },
        onDowngrade: (Database db, int oldVersion, int newVersion) {
          print("onDowngrade");
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) {
          print("onUpgrade");
          _tables = tables;
          for (int i = 0; i < tables.length; i++) {
            db.execute(" DROP TABLE IF EXISTS " + tables[i]._tableName);
          }
        });
  }
}

class DbTable {
  String _tableName;
  List<DbColumn> _dbColumns = [];

  // Constructor --
  DbTable(String tableName, {List<DbColumn> dbColumns}) {
    _tableName = tableName.replaceAll(" ", "_").toUpperCase();

    for (int i = 0; i < dbColumns.length; i++) {
      dbColumns.insert(
          0,
          DbColumn("ID",
              columnDataType: " INTEGER PRIMARY KEY AUTOINCREMENT "));
    }

    _dbColumns = dbColumns;
  }
}

class DbColumn {
  String _columnName = "", _columnDataType = "";

  // Constructor --
  DbColumn(String columnName, {String columnDataType = " TEXT "}) {
    _columnName = " " +
        columnName.replaceAll(" ", "_").replaceAll(".", "_").toUpperCase() +
        " ";
    _columnDataType = columnDataType.toUpperCase();
  }
}

class Datum {
  int _columnIndex;
  String _value = "";

  // Constructor --
  Datum(int columnIndex, String value) {
    _columnIndex = columnIndex;
    _value = value;
  }
}
