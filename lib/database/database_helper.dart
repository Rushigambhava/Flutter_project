import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static DatabaseHelper get instance => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'matrimony.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT,
        email TEXT,
        number TEXT,
        dob TEXT,
        city TEXT,
        gender INTEGER,
        hobbies TEXT,
        password TEXT,
        confirmPassword TEXT,
        isLiked INTEGER DEFAULT 0
      )
    ''');
  }

  // CRUD Operations for Users

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    // Convert hobbies list to string for storage
    user['hobbies'] = user['hobbies'].join(',');
    return await db.insert('users', user);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    Database db = await database;
    List<Map<String, dynamic>> users = await db.query('users');
    return users.map((user) {
      // Convert hobbies string back to list
      user['hobbies'] = user['hobbies'].toString().split(',');
      user['isLiked'] = user['isLiked'] == 1;
      return user;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getFavoriteUsers() async {
    Database db = await database;
    List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'isLiked = ?',
      whereArgs: [1],
    );
    return users.map((user) {
      user['hobbies'] = user['hobbies'].toString().split(',');
      user['isLiked'] = user['isLiked'] == 1;
      return user;
    }).toList();
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    Database db = await database;
    user['hobbies'] = user['hobbies'].join(',');
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> toggleFavorite(int id, bool isLiked) async {
    Database db = await database;
    return await db.update(
      'users',
      {'isLiked': isLiked ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    Database db = await database;
    List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'fullName LIKE ? OR email LIKE ? OR city LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return users.map((user) {
      user['hobbies'] = user['hobbies'].toString().split(',');
      user['isLiked'] = user['isLiked'] == 1;
      return user;
    }).toList();
  }
} 