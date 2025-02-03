import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/user_model.dart';

class DatabaseUser {
  static Database? _database;

  Future<Database> get database async
  {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }


  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'user.db');
    print("Database path: $path");

    return await openDatabase(path, version: 2, onCreate: (db, version) async {
      print("Database Created!");

      await db.execute('''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,  
        name TEXT,
        email TEXT UNIQUE,  
        profilePic TEXT
      )
    ''');
      print("User table created!");

      // Create fav_item table
      await db.execute('''
      CREATE TABLE fav_item(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT,  -- Reference to user email
        name TEXT,
        price REAL,  -- Using REAL for decimal values
        rating REAL, -- Using REAL for decimal ratings
        image TEXT,
        rate INTEGER,
        FOREIGN KEY (email) REFERENCES user(email) ON DELETE CASCADE
      )
    ''');
      print("fav_item table created!");
      await db.execute('''
      CREATE TABLE add_kart(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT,  -- Reference to user email
        name TEXT,
        price REAL,  -- Using REAL for decimal values
        rating REAL, -- Using REAL for decimal ratings
        image TEXT,
        rate INTEGER,
        FOREIGN KEY (email) REFERENCES user(email) ON DELETE CASCADE
      )
    ''');
      print("add_kart table created!");
      await db.execute('''
      CREATE TABLE my_order(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        area TEXT,
        city TEXT,
        district TEXT,
        email TEXT,  -- Reference to user email
        name TEXT,
        price REAL,  -- Using REAL for decimal values
        rating REAL, -- Using REAL for decimal ratings
        image TEXT,
        rate INTEGER,
        total REAL,  -- Added field for total amount
        FOREIGN KEY (email) REFERENCES user(email) ON DELETE CASCADE
      )
    ''');
      print("add_kart table created!");


    }, onUpgrade: (db, oldVersion, newVersion) async {
      print("Database Upgraded from version $oldVersion to $newVersion");
    });
  }
  ///insert
  Future<void> insertCart(Map<String, dynamic> item, String email) async {
    final db = await database;
    await db.insert(
      'add_kart',
      {
        'email': email,
        'name': item['name'],
        'price': item['price'],
        'rating': item['rating'],
        'image': item['image'],
        'rate': item['rate'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> insertOrder(Map<String, dynamic> item, String email, String area, String city, String district, double totalAmount) async {
    final db = await database;
    await db.insert('my_order', {
      'email': email,
      'name': item['name'],
      'price': item['price'],
      'rating': item['rating'],
      'image': item['image'],
      'rate': item['rate'],
      'area': area,
      'city': city,
      'district': district,
      'total': totalAmount,
    });
  }
  Future<void> insertFavorite(Map<String, dynamic> item, String email) async {
    final db = await database;
    if (db == null) {
      print("Database is not initialized!");
      return;
    }
    print("Inserting item: $item for email: $email");
    await db.insert(
      'fav_item',
      {
        'email': email,
        'name': item['name'],
        'price': item['price'],
        'rating': item['rating'],
        'image': item['image'],
        'rate': item['rate'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // This replaces existing data
    );

    print("Item inserted successfully");
  }
  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert('user', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ///get
  Future<List<Map<String, dynamic>>> fetchCart(String userEmail) async {
    final db = await DatabaseUser().database;
    final List<Map<String, dynamic>> result = await db.query(
      'add_kart',
      where: 'email = ?',
      whereArgs: [userEmail],
    );
    return result;
  }
  Future<List<Map<String, dynamic>>> fetchOrder(String userEmail) async {
    final db = await DatabaseUser().database;
    final List<Map<String, dynamic>> result = await db.query(
      'my_order',
      where: 'email = ?',
      whereArgs: [userEmail],
    );
    return result;
  }
  Future<List<Map<String, dynamic>>> fetchFavorites(String userEmail) async {
    final db = await DatabaseUser().database;
    final List<Map<String, dynamic>> result = await db.query(
      'fav_item',
      where: 'email = ?',
      whereArgs: [userEmail],
    );
    return result;
  }
  Future<UserModel?> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('user');
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  ///delete
  Future<void> clearCart(String email) async {
    final db = await database;
    await db.delete('add_kart', where: 'email = ?', whereArgs: [email]);
    print("Cart cleared for email: $email");
  }
  Future<void> clearUser() async {
    final db = await database;
    await db.delete('user');
  }
  Future<void> deleteCart(String name, String email) async {
    final db = await database;
    await db.delete('add_kart', where: 'name = ? AND email = ?', whereArgs: [name, email]);
  }
  Future<void> deleteOrder(String name, String email) async {
    final db = await database;
    await db.delete('my_order', where: 'name = ? AND email = ?', whereArgs: [name, email]);
  }
  Future<void> deleteFavorite(String name, String email) async {
    final db = await database;
    await db.delete('fav_item', where: 'name = ? AND email = ?', whereArgs: [name, email]);
  }

  ///check
  Future<bool> isInCart(String name, String email) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'add_kart',
      where: 'name = ? AND email = ?',
      whereArgs: [name, email],
    );
    return result.isNotEmpty;
  }
  Future<void> checkFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> favorites = await db.query('fav_item');
    print("Favorite Items: $favorites");
  }
  Future<bool> isFavorite(String name, String email) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'fav_item',
      where: 'name = ? AND email = ?',
      whereArgs: [name, email],
    );
    return result.isNotEmpty;
  }

  ///backup
  Future<void> backupDatabase() async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      print('Permission granted');
      final dbPath = join(await getDatabasesPath(), 'user.db');
      final backupPath = '/storage/emulated/0/Download/user_backup.db'; // Save in Downloads folde
      final dbFile = File(dbPath);
      final backupFile = File(backupPath);

      if (await dbFile.exists()) {
        await dbFile.copy(backupFile.path);
        print('Backup saved at: $backupPath');
      } else {
        print('Database not found!');
      }
     } else {
      print('Permission denied');
      return;
    }


  }


}
