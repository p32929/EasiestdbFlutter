import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EasiestDb {
  // Vars
  static String _dbName;
  static int _version = 1;
  static String _dbPath;
  static List<DbTable> _tables = [];
  static Database _db;

  //
  static void deleteDatabase() {
    String SQL = ' DROP DATABASE ${_dbName.replaceAll(".db", "")} ';
    _db.execute(SQL);
  }

  //
  static void deleteTable(int tableIndex) {
    String SQL = ' DROP TABLE ${_tables[tableIndex]._tableName} ';
    _db.execute(SQL);
  }

  //
  static Future<int> deleteDataBySearchingInColumn(
      int tableIndex, Datum datum) {
    String SQL =
        ' DELETE FROM ${_tables[tableIndex]._tableName} WHERE ${_tables[tableIndex]._dbColumns[datum._columnIndex]._columnName} = ${datum._value} ';
    return _db.rawDelete(SQL);
  }

  //
  static Future<int> deleteOneData(int tableIndex, int rowId) {
    String SQL =
        ' DELETE FROM ${_tables[tableIndex]._tableName} WHERE ID = $rowId ';
    return _db.rawDelete(SQL);
  }

  //
  static Future<int> updateOneDataById(
      int tableIndex, int rowId, List<Datum> data) {
    //
    String SQL = ' UPDATE ${_tables[tableIndex]._tableName} SET ';
    List<DbColumn> columns = _tables[tableIndex]._dbColumns;

    for (int i = 0; i < data.length; i++) {
      SQL +=
          " ${columns[data[i]._columnIndex]._columnName} = \'${data[i]._value}\' ";
      if (i == data.length - 1) {
        SQL += " ";
      } else {
        SQL += " , ";
      }
    }

    SQL += " WHERE ID = $rowId ";

    return _db.rawUpdate(SQL);
  }

  //
  static Future<List<Map<String, dynamic>>> getRowsByMatchingColumnData(
      int tableIndex, int columnIndex, var valueToMatch,
      {bool ascending = true}) {
    //
    String orderBy = ascending ? "ASC" : "DESC";
    String SQL =
        ' SELECT * FROM ${_tables[tableIndex]._tableName} WHERE ${_tables[tableIndex]._dbColumns[columnIndex]._columnName}=$valueToMatch ORDER BY ID $orderBy ';
    return _db.rawQuery(SQL);
  }

  //
  static Future<List<Map<String, dynamic>>> getOneRowData(
      int tableIndex, int rowId) {
    //
    String SQL =
        ' SELECT * FROM ${_tables[tableIndex]._tableName} WHERE ID=$rowId ';
    return _db.rawQuery(SQL);
  }

  //
  static Future<List<Map<String, dynamic>>> getAllData(int tableIndex,
      {bool ascending = true}) {
    //
    String orderBy = ascending ? "ASC" : "DESC";
    String SQL =
        ' SELECT * FROM ${_tables[tableIndex]._tableName} ORDER BY ID $orderBy ';
    return _db.rawQuery(SQL);
  }

  //
  static Future<int> addData(int tableIndex, List<Datum> data) {
    //
    String SQL = ' INSERT INTO ${_tables[tableIndex]._tableName} ( ';
    List<DbColumn> columns = _tables[tableIndex]._dbColumns;

    for (int i = 0; i < data.length; i++) {
      SQL += " " + columns[data[i]._columnIndex]._columnName + " ";

      if (i == data.length - 1) {
        SQL += " ) ";
      } else {
        SQL += " , ";
      }
    }

    SQL += " VALUES ( ";

    for (int i = 0; i < data.length; i++) {
      SQL += " \'" + data[i]._value + "\' ";

      if (i == data.length - 1) {
        SQL += " ) ";
      } else {
        SQL += " , ";
      }
    }

    return _db.rawInsert(SQL);
  }

  //
  static Future<List<Map<String, dynamic>>> runCustomSqlQuery(
      String sqlCommand) {
    //
    return _db.rawQuery(sqlCommand);
  }

  static void runCustomSqlCommand(String sqlCommand) {
    _db.execute(sqlCommand);
  }

  //
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
            String SQL = " CREATE TABLE " + tables[i]._tableName + " ( ";

            tables[i]._dbColumns.insert(
                0,
                DbColumn("ID",
                    columnDataType: " INTEGER PRIMARY KEY AUTOINCREMENT "));
            List<DbColumn> columns = tables[i].dbColumns;

            for (int j = 0; j < columns.length; j++) {
              SQL += " " +
                  columns[j]._columnName +
                  " " +
                  columns[j]._columnDataType +
                  " ";

              if (j == columns.length - 1) {
                SQL += " ) ";
              } else {
                SQL += " , ";
              }
            }
            _tables = tables;
            db.execute(SQL);
            print("$_dbName creatd");
          }
        },
        version: _version,
        onConfigure: (Database db) {
          print("onConfigure");
          _tables = tables;
        },
        onOpen: (Database db) {
          print("onOpen");
          _tables = tables;
        },
        onDowngrade: (Database db, int oldVersion, int newVersion) {
          print("onDowngrade");
          _tables = tables;
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

  DbTable(String tableName, {List<DbColumn> dbColumns}) {
    _tableName = tableName.replaceAll(" ", "_").toUpperCase();
    _dbColumns = dbColumns;
  }

  List<DbColumn> get dbColumns => _dbColumns;

  set dbColumns(List<DbColumn> value) {
    _dbColumns = value;
  }

  String get tableName => _tableName;

  set tableName(String value) {
    _tableName = value.replaceAll(" ", "_");
  }
}

class DbColumn {
  String _columnName = "", _columnDataType = "";

  DbColumn(String columnName, {String columnDataType = " TEXT "}) {
    _columnName = " " +
        columnName.replaceAll(" ", "_").replaceAll(".", "_").toUpperCase() +
        " ";
    _columnDataType = columnDataType.toUpperCase();
  }

  get columnDataType => _columnDataType;

  set columnDataType(value) {
    _columnDataType = value;
  }

  String get columnName => _columnName;

  set columnName(String value) {
    _columnName = value.replaceAll(" ", "_");
  }
}

class Datum {
  int _columnIndex;
  String _value = "";

  Datum(int columnIndex, String value) {
    _columnIndex = columnIndex;
    _value = value;
  }

  String get value => _value;

  set value(String value) {
    _value = value;
  }

  int get columnIndex => _columnIndex;

  set columnIndex(int value) {
    _columnIndex = value;
  }
}
