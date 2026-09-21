# easiestdb

![easiestdb](https://user-images.githubusercontent.com/6418354/87636772-0ce14100-c763-11ea-8d8b-0c7c36ae5ebe.png)

The easiest and laziest approach to a SQLite database in Flutter. Declare your tables and columns once, then do CRUD without writing a single SQL query — `sqflite` underneath, so anything it can do, you can still do.

On pub.dev: **[easiestdb](https://pub.dev/packages/easiestdb)**

[![pub version](https://badgen.net/pub/v/easiestdb)](https://pub.dev/packages/easiestdb) [![pub likes](https://badgen.net/pub/likes/easiestdb)](https://pub.dev/packages/easiestdb)

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
Lastly, I wanna thank the Flutter team for the amazing framework and [tekartik](https://github.com/tekartik/) for the sqflite library.
And thanks to everyone for using `easiestdb` and thanks in advance to everyone for contributing...

Also, you might wanna try the Android/Java version of this library from here: https://github.com/p32929/EasiestSqlLibrary

## Contributing

Contributions are warmly welcomed and greatly appreciated! Whether it's a bug fix, new feature, or improvement, your input helps make this project better for everyone.

Before submitting a pull request, please:

1. Create an issue describing the feature or bug fix you'd like to work on
2. Wait for discussion and approval to ensure alignment with project goals
3. Fork the repository and create your feature branch
4. Submit your pull request with a clear description of changes

This approach helps avoid duplicate efforts and ensures smooth collaboration. Thank you for considering contributing!

## Share

Sharing this repository with your friends is just one click away from here

[![facebook](https://user-images.githubusercontent.com/6418354/179013321-ac1d1452-0689-493f-9066-940cf2302b6e.png)](https://www.facebook.com/sharer/sharer.php?u=https://github.com/p32929/EasiestdbFlutter/)
[![twitter](https://user-images.githubusercontent.com/6418354/179013351-7d8d6d1c-4ce2-46ab-bef8-4c4765a1b888.png)](https://twitter.com/intent/tweet?url=https://github.com/p32929/EasiestdbFlutter/)
[![tumblr](https://user-images.githubusercontent.com/6418354/179013343-3111f55a-3b90-40c7-8487-9777348672b0.png)](https://www.tumblr.com/share?v=3&u=https://github.com/p32929/EasiestdbFlutter/)
[![pocket](https://user-images.githubusercontent.com/6418354/179013334-b095c45f-becf-49f4-9ee1-5a731a9b1f85.png)](https://getpocket.com/save?url=https://github.com/p32929/EasiestdbFlutter/)
[![pinterest](https://user-images.githubusercontent.com/6418354/179013331-44cd9206-11b1-4b65-becb-5863b61c828f.png)](https://pinterest.com/pin/create/button/?url=https://github.com/p32929/EasiestdbFlutter/)
[![reddit](https://user-images.githubusercontent.com/6418354/179013338-7416ae3f-73ba-4522-86e1-1374d7082d22.png)](https://www.reddit.com/submit?url=https://github.com/p32929/EasiestdbFlutter/)
[![linkedin](https://user-images.githubusercontent.com/6418354/179013327-ca7b7102-1da8-4b1c-858f-1a6e5f21bd70.png)](https://www.linkedin.com/shareArticle?mini=true&url=https://github.com/p32929/EasiestdbFlutter/)
[![whatsapp](https://user-images.githubusercontent.com/6418354/179013353-f477fa0b-3e6f-4138-a357-c9991b23ff88.png)](https://api.whatsapp.com/send?text=https://github.com/p32929/EasiestdbFlutter/)

---

## Support

If this saved you time, you can buy me a coffee — it keeps these projects maintained and free. Other payment options: https://p32929.github.io/SendMoney2MeV1/

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20me%20a%20coffee-%E2%98%95-FFDD00?style=for-the-badge&logo=buymeacoffee&logoColor=black)](https://www.buymeacoffee.com/p32929)

<!-- hire-block -->

---

## 💼 Need this customised — or need it yesterday?

I take fixed-price Flutter work on my own projects. No hourly billing, no surprise scope:

| | |
|---|---|
| **Drop-in integration** — I wire this into your codebase and hand you a PR that builds | **$45** · 3 days |
| **Priority bug fix or small feature** — jumps ahead of the free issue queue | **$95** · 72 hours |
| **Custom build** — branded, packaged and deployed, source yours | **$130** · 7 days |
| **A full app from scratch** | **from $350** · quoted first |

All prices and how to buy → **[p32929.github.io/hire](https://p32929.github.io/hire/)**  
Or buy through [Fiverr](https://www.fiverr.com/fayazbinsalam) (escrow, ID-verified, 5.0★) — safest for a first job.

Scoping and quotes are free: [open an issue](https://github.com/p32929/hire/issues/new) and describe the job.
