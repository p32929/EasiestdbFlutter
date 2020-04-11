import 'package:easiestdb/easiestdb.dart';

void main() {

  // init ---
  EasiestDb.init(dbName: "Data", version: 2, tables: [
    DbTable("People", dbColumns: [
      DbColumn('Col 1'),
      DbColumn('Col 2'),
    ]),
    DbTable("Test", dbColumns: [
      DbColumn('Col 3'),
      DbColumn('Col 4', columnDataType: "UNIQUE"),
    ]),
  ]);

  // addData ---
  EasiestDb.addData(0, [
    Datum(1, "AAA"),
    Datum(2, "BBB"),
  ]).then((id) {
    print("ID: $id");
  });

  // getAllData ---
  EasiestDb.getAllData(0).then((listMap) {
    listMap.forEach((map) {
      print("${map.values.elementAt(0)}"); // Showing the value of the ID column
      print("${map.values.elementAt(1)}"); // Showing the value from another column
    });
  });

  // getOneRowData ---
  EasiestDb.getOneRowData(0, 7).then((listMap) {
    listMap.forEach((map) {
      print("${map.values.elementAt(0)}"); // Showing the value of the ID column
      print("${map.values.elementAt(1)}"); // Showing the value from another column
    });
  });

  // getRowsByMatchingColumnData ---
  EasiestDb.getRowsByMatchingColumnData(0, 1, 'AAA').then((listMap) {
    listMap.forEach((map) {
      print("${map.values.elementAt(0)}"); // Showing the value of the ID column
      print("${map.values.elementAt(1)}"); // Showing the value from another column
    });
  });

  // updateOneDataById ---
  EasiestDb.updateOneDataById(0, 7, [
    Datum(1, "F F F F F F "),
    Datum(2, "G G G G G G "),
  ]).then((count) {
    print("Count: $count");
  });

  // deleteOneData ---
  EasiestDb.deleteOneData(0, 7).then((val) {
    print("Count: $val");
  });

  // deleteDataBySearchingInColumn ---
  EasiestDb.deleteDataBySearchingInColumn(0, Datum(
      1, "F F F F F F "
  )).then((val) {
    print("Count: $val");
  });

  // deleteTable ---
  EasiestDb.deleteTable(1);

  // deleteDatabase ---
  EasiestDb.deleteDatabase();
}
