// import 'package:sqflite/sqflite.dart';
// import 'db_helper.dart';
// import '../../models/product.dart';

// class ProductDao {
//   final dbHelper = DBHelper();

//   Future<List<Product>> getAll() async {
//     final db = await dbHelper.database;
//     final maps = await db.query('products');
//     return maps.map((e) => Product.fromMap(e)).toList();
//   }

//   Future<void> upsert(Product p) async {
//     final db = await dbHelper.database;
//     await db.insert('products', p.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<List<Product>> getDirtySince(DateTime since) async {
//     final db = await dbHelper.database;
//     final maps = await db.query(
//       'products',
//       where: 'isDirty = 1 AND updatedAt >= ?',
//       whereArgs: [since.toIso8601String()],
//     );
//     return maps.map((e) => Product.fromMap(e)).toList();
//   }

//   Future<void> clearDirtyFlag(String id) async {
//     final db = await dbHelper.database;
//     await db.update('products', {'isDirty': 0}, where: 'id = ?', whereArgs: [id]);
//   }
// }