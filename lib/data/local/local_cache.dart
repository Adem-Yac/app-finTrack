import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class LocalCache {
  Database? _db;

  bool get _useSqlite => !kIsWeb;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    final dir = await getDatabasesPath();
    _db = await openDatabase(
      p.join(dir, 'fintrack.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE kv (key TEXT PRIMARY KEY, value TEXT NOT NULL)',
        );
      },
    );
    return _db!;
  }

  Future<void> putJson(String key, Object value) async {
    final encoded = jsonEncode(value);
    if (_useSqlite) {
      final db = await database;
      await db.insert('kv', {
        'key': key,
        'value': encoded,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cache_$key', encoded);
  }

  Future<Map<String, dynamic>?> getJson(String key) async {
    if (_useSqlite) {
      final db = await database;
      final rows = await db.query(
        'kv',
        where: 'key = ?',
        whereArgs: [key],
        limit: 1,
      );
      if (rows.isNotEmpty) {
        return jsonDecode(rows.first['value'] as String)
            as Map<String, dynamic>;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('cache_$key');
    if (raw == null) {
      return null;
    }
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return null;
  }

  Future<List<dynamic>?> getList(String key) async {
    final json = await getJson(key);
    if (json != null) {
      return json['items'] as List<dynamic>?;
    }
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('cache_$key');
    if (raw == null) {
      return null;
    }
    final decoded = jsonDecode(raw);
    return decoded is List ? decoded : null;
  }
}
