![New Project](https://user-images.githubusercontent.com/6418354/87636772-0ce14100-c763-11ea-8d8b-0c7c36ae5ebe.png)

The Easiest and the Laziest approach to Flutter SQL Database.

 • <a href="#basic-usage">How to use</a> •
<a href="#contribution">Contribution</a> •
<a href="#license">License</a> •
<a href="#support">Support</a> •


[![](https://badgen.net/github/watchers/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/stars/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/forks/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/issues/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/open-issues/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/closed-issues/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/label-issues/p32929/EasiestSqlFlutter/help-wanted/open)]() [![](https://badgen.net/github/prs/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/open-prs/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/closed-prs/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/merged-prs/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/commits/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/last-commit/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/branches/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/releases/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/tags/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/license/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/contributors/p32929/EasiestSqlFlutter)]() [![](https://badgen.net/github/dependents-pkg/p32929/EasiestSqlFlutter)]() 

[![](https://badgen.net/pub/v/easiestdb)]() [![](https://badgen.net/pub/likes/easiestdb)]() [![](https://badgen.net/pub/sdk-version/easiestdb)]() [![](https://badgen.net/pub/flutter-platform/easiestdb)]() 

## Installation
check out the [pub.dev](https://pub.dev/packages/easiestdb) for updated installation instructions

## Basic Usage
Init using Database name, Table names and Column names. After that, you can do all kinds of CRUD ( Create, Read, Update, Delete ) operations.

Add as many tables and columns you want using these simple codes.

## Initialize the Database and the Tables
###### `static Future<Database> init({ String dbName = 'demo.db', int version = 1, List<DbTable> tables })`
###### `DbTable(String tableName, {List<DbColumn> dbColumns})`
###### `DbColumn(String columnName, {String columnDataType = " TEXT "})`

Suppose, we're trying to create a database of two tables named People and Test, each containing three columns.
So, we'll write:
```
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

```
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

```
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

```
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

```
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

```
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

```
EasiestDb.deleteOneData(0, 7).then((val) {
    print("Count: $val");
});
```

## Delete a row if value matches in a column
###### `static Future<int> deleteDataBySearchingInColumn(int tableIndex, Datum datum)`
###### `Datum(int columnIndex, String value)`

Delete a one/more data from the first table if matches value in the 2nd(1) column:

```
EasiestDb.deleteDataBySearchingInColumn(0, Datum(
    1, "F F F F F F "
)).then((val) {
    print("Count: $val");
});
```

## Delete all data from a table
###### `static void deleteTable(int tableIndex)`

Delete/Drop the 2nd(1) table:

```
EasiestDb.deleteTable(1);
```

## Delete the all data from the database
###### `static void deleteDatabase()`

Delete/Drop the whole database:

```
EasiestDb.deleteDatabase();
```

## Run custom SQL commands
###### `static Database getDatabaseObject()`

And last but not the least, if you're trying to do something but there's no a function/method created for that command, you can always get the database object and run any custom command like below:

```
EasiestDb.getDatabaseObject().execute(sqlCommand)
```

But if you really want that function implemented in `easiestdb` library, you can: 
1. fork the repo
2. create a new branch by your `github username`
3. add the code
4. commit + push
5. make a pull request.

You're welcome...

## License
```
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

```

## Contribution
Lastly, I wanna thank the Flutter team for the amazing framework and [tekartik](https://github.com/tekartik/) for the sqflite library.
And thanks to everyone for using `easiestdb` and thanks in advance to everyone for contributing...

Also, you might wanna try the Android/Java version of this library from here: https://github.com/p32929/EasiestSqlLibrary

## Support
If you like my works and want to support me/my works, feel free to [Support or Donate](p32929.github.io/SendMoney2Me/)