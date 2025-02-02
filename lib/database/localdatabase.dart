import 'dart:io';

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

  // add_kart table
  // field namme sollu crate pant
  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'user.db');
    print("Database path: $path"); // Debugging path

    return await openDatabase(path, version: 2, onCreate: (db, version) async {
      print("Database Created!");

      // Create user table
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

    }, onUpgrade: (db, oldVersion, newVersion) async {
      print("Database Upgraded from version $oldVersion to $newVersion");
    });
  }

  Future<void> backupDatabase() async {
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
  }




  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert('user', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserModel?> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('user');
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  Future<void> clearUser() async {
    final db = await database;
    await db.delete('user');
  }
}
