// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// import '../models/user_model.dart';
// import '../models/item_model.dart';
// import '../models/stock_count_model.dart';

// class DBService {
//   DBService._privateConstructor();
//   static final DBService instance = DBService._privateConstructor();

//   static Database? _database;

//   Future<Database> get database async => _database ??= await _initDB();

//   Future<Database> _initDB() async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, 'stock_tracking.db');

//     return await openDatabase(
//       path,
//       version: 3, // Bumped version for schema update
//       onCreate: _onCreate,
//       onUpgrade: _onUpgrade,
//     );
//   }

//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE user_masters (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         username TEXT NOT NULL UNIQUE,
//         password TEXT NOT NULL
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE item_masters (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         api_id TEXT UNIQUE,
//         qr_code TEXT NOT NULL UNIQUE,
//         name TEXT NOT NULL,
//         description TEXT,
//         count INTEGER DEFAULT 0
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE stock_counts (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         item_id TEXT NOT NULL,
//         barcode TEXT,
//         description TEXT,
//         count INTEGER NOT NULL,
//         last_updated TEXT NOT NULL,
//         FOREIGN KEY (item_id) REFERENCES item_masters(id)
//       )
//     ''');

//     // Default admin user
//     await db.insert('user_masters', {
//       'username': 'admin',
//       'password': 'admin123',
//     });
//   }

//   Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
//     if (oldVersion < 2) {
//       await db
//           .execute('ALTER TABLE item_masters ADD COLUMN api_id TEXT UNIQUE');
//     }
//     if (oldVersion < 3) {
//       await db.execute('ALTER TABLE stock_counts ADD COLUMN barcode TEXT');
//       await db.execute('ALTER TABLE stock_counts ADD COLUMN description TEXT');
//     }
//   }

//   // User operations
//   Future<UserModel?> getUser(String username, String password) async {
//     final db = await database;
//     final res = await db.query(
//       'user_masters',
//       where: 'username = ? AND password = ?',
//       whereArgs: [username, password],
//     );
//     if (res.isNotEmpty) {
//       return UserModel.fromMap(res.first);
//     }
//     return null;
//   }

//   Future<int> insertUser(UserModel user) async {
//     final db = await database;
//     return await db.insert(
//       'user_masters',
//       user.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   // Item operations
//   Future<ItemModel?> getItemByQrCode(String qrCode) async {
//     final db = await database;
//     final res = await db.query(
//       'item_masters',
//       where: 'qr_code = ?',
//       whereArgs: [qrCode],
//     );
//     if (res.isNotEmpty) {
//       return ItemModel.fromMap(res.first);
//     }
//     return null;
//   }

//   Future<int> insertItem(ItemModel item) async {
//     final db = await database;
//     return await db.insert(
//       'item_masters',
//       item.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<int> updateItemCount(String itemId, int newCount) async {
//     final db = await database;
//     return await db.update(
//       'item_masters',
//       {'count': newCount},
//       where: 'id = ?',
//       whereArgs: [itemId],
//     );
//   }

//   Future<int> getLatestStockCount(String itemId) async {
//     final db = await database;
//     final result = await db.query(
//       'stock_counts',
//       where: 'item_id = ?',
//       whereArgs: [itemId],
//       orderBy: 'id DESC',
//       limit: 1,
//     );

//     if (result.isNotEmpty) {
//       return result.first['count'] as int;
//     } else {
//       return 0;
//     }
//   }

//   Future<List<StockCountModel>> getAllStockCounts() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('stock_counts');

//     return List.generate(maps.length, (i) {
//       return StockCountModel.fromMap(maps[i]);
//     });
//   }

//   Future<String> getItems() async {
//     final db = await database;

//     final List<Map<String, dynamic>> maps = await db.query('item_masters');

//     List<ItemModel> items = maps.map((map) => ItemModel.fromMap(map)).toList();

//     // Print each item
//     for (var item in items) {
//       print('ID: ${item.id}, Name: ${item.name}');
//     }

//     return "jhjdfhd";
//   }

//   // Stock count operations
//   Future<int> insertStockCount(StockCountModel stockCount) async {
//     final db = await database;
//     return await db.insert(
//       'stock_counts',
//       stockCount.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
// }

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user_model.dart';
import '../models/item_model.dart';
import '../models/stock_count_model.dart';

class DBService {
  DBService._privateConstructor();
  static final DBService instance = DBService._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDB();

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'stock_tracking.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_masters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE item_masters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        api_id TEXT UNIQUE,
        qr_code TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        description TEXT,
        count INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE stock_counts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id TEXT NOT NULL,
        barcode TEXT,
        description TEXT,
        count INTEGER NOT NULL,
        last_updated TEXT NOT NULL,
        FOREIGN KEY (item_id) REFERENCES item_masters(id)
      )
    ''');

    await db.insert('user_masters', {
      'username': 'admin',
      'password': 'admin123',
    });
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE item_masters ADD COLUMN api_id TEXT UNIQUE');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE stock_counts ADD COLUMN barcode TEXT');
      await db.execute('ALTER TABLE stock_counts ADD COLUMN description TEXT');
    }
  }

  Future<UserModel?> getUser(String username, String password) async {
    final db = await database;
    final res = await db.query(
      'user_masters',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (res.isNotEmpty) {
      return UserModel.fromMap(res.first);
    }
    return null;
  }

  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert(
      'user_masters',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<ItemModel?> getItemByQrCode(String qrCode) async {
    final db = await database;
    final res = await db.query(
      'item_masters',
      where: 'qr_code = ?',
      whereArgs: [qrCode],
    );
    if (res.isNotEmpty) {
      return ItemModel.fromMap(res.first);
    }
    return null;
  }

  Future<int> insertItem(ItemModel item) async {
    final db = await database;
    return await db.insert(
      'item_masters',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateItemCount(String itemId, int newCount) async {
    final db = await database;
    return await db.update(
      'item_masters',
      {'count': newCount},
      where: 'id = ?',
      whereArgs: [itemId],
    );
  }

  Future<int> getLatestStockCount(String itemId) async {
    final db = await database;
    final result = await db.query(
      'stock_counts',
      where: 'item_id = ?',
      whereArgs: [itemId],
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['count'] as int;
    } else {
      return 0;
    }
  }

  Future<List<StockCountModel>> getAllStockCounts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('stock_counts');

    return List.generate(maps.length, (i) {
      return StockCountModel.fromMap(maps[i]);
    });
  }

  Future<String> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('item_masters');
    List<ItemModel> items = maps.map((map) => ItemModel.fromMap(map)).toList();
    for (var item in items) {
      print('ID: ${item.id}, Name: ${item.name}');
    }
    return "Loaded";
  }

  Future<int> updateStockCount({
    required String itemId,
    required String qrCode,
    required String? description,
    required int addCount,
    required String updatedTime,
  }) async {
    final db = await database;

    final existing = await db.query(
      'stock_counts',
      where: 'item_id = ?',
      whereArgs: [itemId],
      orderBy: 'id DESC',
      limit: 1,
    );

    int newCount = addCount;

    if (existing.isNotEmpty) {
      final existingId = existing.first['id'] as int;
      final existingCount = existing.first['count'] as int;
      newCount = existingCount + addCount;

      await db.update(
        'stock_counts',
        {
          'count': newCount,
          'last_updated': updatedTime,
        },
        where: 'id = ?',
        whereArgs: [existingId],
      );
    } else {
      await db.insert('stock_counts', {
        'item_id': itemId,
        'barcode': qrCode,
        'description': description,
        'count': newCount,
        'last_updated': updatedTime,
      });
    }

    await db.update(
      'item_masters',
      {'count': newCount},
      where: 'id = ?',
      whereArgs: [itemId],
    );

    return newCount;
  }
}


