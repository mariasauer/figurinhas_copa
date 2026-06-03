import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/figurinha.dart';
import 'dart:convert'; 
import 'package:flutter/services.dart'; 

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('album_copa.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    Directory dbFolder = await getApplicationDocumentsDirectory();
    String path = join(dbFolder.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE figurinhas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code STRING NOT NULL, 
        name TEXT NOT NULL,
        type TEXT,
        colada INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> inserir(Figurinha figurinha) async {
    final db = await instance.database;
    return await db.insert('figurinhas', figurinha.toMap());
  }

  Future<List<Figurinha>> listarTodas() async {
    final db = await instance.database;
    final result = await db.query('figurinhas', orderBy: 'id ASC');
    return result.map((json) => Figurinha.fromMap(json)).toList();
  }

  Future<int> atualizar(Figurinha figurinha) async {
    final db = await instance.database;
    return await db.update(
      'figurinhas',
      figurinha.toMap(),
      where: 'id = ?',
      whereArgs: [figurinha.id],
    );
  }

  Future<Map<String, int>> obterEstatisticasGlobais() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT COUNT(id) as total_coladas 
      FROM figurinhas 
      WHERE colada = 1
    ''');

    int totalColadas = result.first['total_coladas'] as int? ?? 0;

    return {
      'coladas': totalColadas,
    };
  }

  Future<void> popularBancoSeVazio() async {
    final db = await instance.database;
    
    // Verifica quantas figurinhas existem no banco
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM figurinhas'));

    if (count == 0) {
      String jsonString = await rootBundle.loadString('assets/figurinhas.json');
      
      Map<String, dynamic> jsonCompleto = jsonDecode(jsonString);

      List<dynamic> jsonList = jsonCompleto['stickers'];

      // inserir todas as figurinhas de uma vez
      Batch batch = db.batch();
      
      for (var item in jsonList) {
         batch.insert('figurinhas', {
           'name': item['name'] ?? 'Jogador',
           'type': item['type'] ?? 'normal',           
           'code': item['code'] ?? '0',
           'colada': 0
         });
      }
      
      await batch.commit();
    }
  }
Future<Map<String, int>> obterResumoColecao() async {
    Database db = await instance.database;

    int total = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM figurinhas')) ?? 0;
    int coladas = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM figurinhas WHERE colada = 1')) ?? 0;

    int totalShiny = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM figurinhas WHERE LOWER(type) = 'shiny'")) ?? 0;
    int shinyColadas = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM figurinhas WHERE LOWER(type) = 'shiny' AND colada = 1")) ?? 0;

    int totalCoca = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM figurinhas WHERE LOWER(type) = 'coca'")) ?? 0;
    int cocaColadas = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM figurinhas WHERE LOWER(type) = 'coca' AND colada = 1")) ?? 0;

    return {
      'total': total,
      'coladas': coladas,
      'totalShiny': totalShiny,
      'shinyColadas': shinyColadas,
      'totalCoca': totalCoca,   
      'cocaColadas': cocaColadas, 
    };
  }
}