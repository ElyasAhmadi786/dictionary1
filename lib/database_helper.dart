import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "sqlite_dictionary.db";
  static final _databaseVersion = 1;

  static Database? _database;

  // Singleton pattern برای ایجاد یک instance از DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  // متد دسترسی به دیتابیس
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase(); // اگر دیتابیس قبلا مقداردهی نشده، آن را مقداردهی می‌کند
    return _database!;
  }

  // متد مقداردهی دیتابیس و ساختن جدول favorites در صورت عدم وجود آن
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    if (!await File(path).exists()) {
      // اگر دیتابیس وجود ندارد، دیتابیس را از assets کپی می‌کند
      ByteData data = await rootBundle.load(join('assets', _databaseName));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }

    // باز کردن دیتابیس و اطمینان از ساختن جدول favorites
    Database db = await openDatabase(path, version: _databaseVersion, onOpen: (db) async {
      // ایجاد جدول favorites در صورت عدم وجود
      await db.execute('''
        CREATE TABLE IF NOT EXISTS favorites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          word_id INTEGER NOT NULL,
          FOREIGN KEY (word_id) REFERENCES words (id) ON DELETE CASCADE
        )
      ''');
    });

    return db;
  }

  // متد تشخیص زبان ورودی (فارسی یا انگلیسی)
  bool _isPersian(String text) {
    final RegExp persianRegExp = RegExp(r'^[\u0600-\u06FF]');
    return persianRegExp.hasMatch(text); // اگر کلمه فارسی باشد true برمی‌گرداند
  }

  // جستجوی لغات بر اساس ورودی (فارسی یا انگلیسی)
  Future<List<Map<String, dynamic>>> searchWord(String query) async {
    final db = await database;
    String columnToSearch = _isPersian(query) ? 'persion_word' : 'english_word'; // انتخاب ستون بر اساس زبان ورودی
    return await db.query(
      'words', // جستجو در جدول words
      columns: ['id', 'persion_word', 'english_word'], // واکشی id، کلمه فارسی و انگلیسی
      where: '$columnToSearch LIKE ?', // شرط جستجو
      whereArgs: ['%$query%'], // تطابق جزئی
    );
  }

  // افزودن کلمه به جدول علاقه‌مندی‌ها
  Future<void> addToFavorites(int wordId) async {
    final db = await database;
    await db.insert(
      'favorites', // درج در جدول favorites
      {'word_id': wordId}, // اضافه کردن word_id
      conflictAlgorithm: ConflictAlgorithm.replace, // جلوگیری از تکرار
    );
  }

  // حذف کلمه از علاقه‌مندی‌ها
  Future<void> removeFromFavorites(int wordId) async {
    final db = await database;
    await db.delete(
      'favorites', // حذف از جدول favorites
      where: 'word_id = ?', // شرط حذف
      whereArgs: [wordId], // شناسه کلمه
    );
  }

  // بررسی اینکه آیا کلمه در علاقه‌مندی‌ها وجود دارد یا نه
  Future<bool> isFavorite(int wordId) async {
    final db = await database;
    var result = await db.query(
      'favorites', // جستجو در جدول favorites
      where: 'word_id = ?', // شرط جستجو
      whereArgs: [wordId], // شناسه کلمه
    );
    return result.isNotEmpty; // اگر نتیجه‌ای موجود بود، true برمی‌گرداند
  }

  // واکشی تمام کلمات موجود در علاقه‌مندی‌ها
  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;

    String query = '''
      SELECT words.id, words.persion_word, words.english_word
      FROM words
      INNER JOIN favorites ON words.id = favorites.word_id
    ''';

    return await db.rawQuery(query); // برگرداندن لیست کلمات علاقه‌مندی‌ها
  }
}
