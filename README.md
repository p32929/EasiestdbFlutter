# easiestdb

![easiestdb](https://user-images.githubusercontent.com/6418354/87636772-0ce14100-c763-11ea-8d8b-0c7c36ae5ebe.png)

The easiest and laziest approach to a SQLite database in Flutter. Declare your tables and columns once, then do CRUD without writing a single SQL query — `sqflite` underneath, so anything it can do, you can still do.

On pub.dev: **[easiestdb](https://pub.dev/packages/easiestdb)**

[![pub version](https://badgen.net/pub/v/easiestdb)](https://pub.dev/packages/easiestdb) [![pub likes](https://badgen.net/pub/likes/easiestdb)](https://pub.dev/packages/easiestdb)

> **Good to know:** easiestdb is marked as discontinued on pub.dev. It still works, but it is no longer updated.

## Installation

```bash
flutter pub add easiestdb
```

## Basic Usage
Init using Database name, Table names and Column names. After that, you can do all kinds of CRUD ( Create, Read, Update, Delete ) operations.

Add as many tables and columns you want using these simple codes.

## Initialize the Database and the Tables
###### `static Future<Database> init({ String dbName = 'demo.db', int version = 1, List<DbTable> tables })`
###### `DbTable(String tableName, {List<DbColumn> dbColumns})`
###### `DbColumn(String columnName, {String columnDataType = " TEXT "})`

Suppose, we're trying to create a database of two tables named People and Test, each containing three columns.
So, we'll write:
```dart
EasiestDb.init(dbName: "Data", version: 1, dbTables: [
    DbTable("People", dbColumns: [
      DbColumn('Col 1'), // Default data type is TEXT
      DbColumn('Col 2'),
    ]),
    DbTable("Test", dbColumns: [
      DbColumn('Col 3'),
      DbColumn('Col 4', columnDataType: "TEXT UNIQUE"),
    ]),
  ]);
```
Look carefully, we didn't add any `ID primary key` column. That's because `easiestdb` library does it by default for each table.

Also, you may add as many SQL Constrains in `columnDataType` parameter. By default, its set to ` TEXT `.

## Add data
###### `static Future<int> addData(int tableIndex, List<Datum> data)`
###### `Datum(int columnIndex, String value)`

Add data in the 1st(0) table:

```dart
EasiestDb.addData(0, [
    Datum(1, "AAA"),
    Datum(2, "123"),
]).then((id) {
    print("ID: $id");
});
```

To pass anything other than `string` in `addData` function, you can just convert them to String and pass it ( may be by using `yourValue.toString()` )

## Get All data from a table
###### `static Future<List<Map<String, dynamic>>> getAllData(int tableIndex, {bool ascending = true})`

Get all data from the 1st(0) table ( all the indexes start from 0 )

```dart
EasiestDb.getAllData(0).then((listMap) {
    listMap.forEach((map) {
        print("${map.values.elementAt(0)}"); // Showing the value of the ID column
        print("${map.values.elementAt(1)}"); // Showing the value from another column
    });
});
```

## Get one data
###### `static Future<List<Map<String, dynamic>>> getOneRowData(int tableIndex, int rowId)`

Get data from the 1st(0) table and the 7th(7) row ( all the indexes start from 0 but the rowId starts from 1 )

```dart
EasiestDb.getOneRowData(0, 7).then((listMap) {
    listMap.forEach((map) {
        print("${map.values.elementAt(0)}"); // Showing the value of the ID column
        print("${map.values.elementAt(1)}"); // Showing the value from another column
    });
});
```

## Search data
###### `static Future<List<Map<String, dynamic>>> getRowsByMatchingColumnData(int tableIndex, int columnIndex, var valueToMatch, {bool ascending = true})`

Searching data in 1st(0) table in the 2nd(1) column by a value:

```dart
EasiestDb.getRowsByMatchingColumnData(0, 1, 'AAA').then((listMap) {
    listMap.forEach((map) {
        print("${map.values.elementAt(0)}"); // Showing the value of the ID column
        print("${map.values.elementAt(1)}"); // Showing the value from another column
    });
});
```

## Update data in a row
###### `static Future<int> updateOneDataById(int tableIndex, int rowId, List<Datum> data)`
###### `Datum(int columnIndex, String value)`

Update data in the first table (0), 7th(7) row:

```dart
EasiestDb.updateOneDataById(0, 7, [
    Datum(1, "F F F F F F "),
    Datum(2, "G G G G G G "),
]).then((count) {
    print("Count: $count");
});
```

## Delete one row data
###### `static Future<int> deleteOneData(int tableIndex, int rowId)`

Delete the 7th(7) row from the 1st(0) table:

```dart
EasiestDb.deleteOneData(0, 7).then((val) {
    print("Count: $val");
});
```

## Delete a row if value matches in a column
###### `static Future<int> deleteDataBySearchingInColumn(int tableIndex, Datum datum)`
###### `Datum(int columnIndex, String value)`

Delete a one/more data from the first table if matches value in the 2nd(1) column:

```dart
EasiestDb.deleteDataBySearchingInColumn(0, Datum(
    1, "F F F F F F "
)).then((val) {
    print("Count: $val");
});
```

## Delete all data from a table
###### `static void deleteTable(int tableIndex)`

Delete/Drop the 2nd(1) table:

```dart
EasiestDb.deleteTable(1);
```

## Delete the all data from the database
###### `static void deleteDatabase()`

Delete/Drop the whole database:

```dart
EasiestDb.deleteDatabase();
```

## Run custom SQL commands
###### `static Database getDatabaseObject()`

And last but not the least, if you're trying to do something but there's no a function/method created for that command, you can always get the database object and run any custom command like below:

```dart
EasiestDb.getDatabaseObject().execute(sqlCommand)
```

If you want that helper implemented in `easiestdb` itself, see the contributing section below.

## License

MIT License — Copyright (c) 2020 Fayaz Bin Salam. See [LICENSE](LICENSE) for the full text.

## Thanks
Thank you to the Flutter team for the amazing framework and [tekartik](https://github.com/tekartik/) for the sqflite library.
And thanks to everyone for using `easiestdb` and thanks in advance to everyone for contributing...

Also, you might wanna try the Android/Java version of this library from here: https://github.com/p32929/EasiestSqlLibrary

## Contributing

Contributions are very welcome, thank you! Before you start on a pull request, please open an issue and tell me what you would like to add or change. That way we can agree on it first, and your time is not wasted on something that might not fit. Thanks for helping make easiestdb better.

<p><a href="https://p32929.github.io/share/?repo=EasiestdbFlutter"><picture><source media="(prefers-color-scheme: dark)" srcset="https://p32929.github.io/readme/footer-share-dark.svg"><img src="https://p32929.github.io/readme/footer-share-light.svg" width="50%" align="top" alt="Share this project with your friends in one click"></picture></a><a href="https://p32929.github.io/support/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://p32929.github.io/readme/footer-support-dark.svg"><img src="https://p32929.github.io/readme/footer-support-light.svg" width="50%" align="top" alt="If you like my work and want to support me, feel free to support"></picture></a><br><a href="https://openstore.pfay.workers.dev/add"><picture><source media="(prefers-color-scheme: dark)" srcset="https://p32929.github.io/readme/footer-join-dark.svg"><img src="https://p32929.github.io/readme/footer-join-light.svg" width="100%" align="top" alt="Put your own apps on OpenStore: free, your listing lives in your own repo"></picture></a></p>
