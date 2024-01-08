
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'agenda.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY,
        date TEXT,
        title VARCHAR(100) NULL,
        content TEXT NULL
      )
    ''');
  }
  Future<int> insertNote(Note note) async {
    Database db = await database;
    return await db.insert('notes', note.toMap());
  }
  Future<List<Note>> getAllNotes() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'notes',
      orderBy: 'id DESC', // Triez par la colonne 'date' de manière décroissante
    );
    return result.map((map) => Note.fromMap(map)).toList();
  }


  Future<int> updateNote(Note note) async {
    Database db = await database;
    return await db.update('notes', note.toMap(),
        where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    Database db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<Note?> getNoteById(int id) async {
    Database db = await database;

    // Exécutez une requête pour récupérer la note avec l'ID donné
    List<Map<String, dynamic>> result = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    // Vérifiez si la requête a renvoyé des résultats
    if (result.isNotEmpty) {
      // Mappez les données de la première ligne pour créer un objet Note
      return Note.fromMap(result.first);
    } else {
      // Aucune note trouvée avec l'ID donné
      return null;
    }
  }


}
class Note {
  int? id;
  String date;
  String? title;
  String? content;

  Note({this.id, required this.date ,this.title, this.content});

  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date, 'title': title, 'content': content};
  }
  @override
  String toString() {
    return jsonEncode(toMap());
  }
  String getFormattedMonthShort() {
    DateTime dateTime = DateTime.parse(date);
    return getMonthShort(dateTime.month);
  }
  String getMonthShort(int month) {
    return DateFormat('MMM', 'fr').format(DateTime(2022, month, 1));
  }


  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(id: map['id'],  date: map['date'], title: map['title'], content: map['content']); // Utilisez 'file' ici
  }
}
