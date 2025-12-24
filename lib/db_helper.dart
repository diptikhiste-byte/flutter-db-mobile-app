import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  // Get database instance
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  // Initialize database
  initDB() async {
    String path = join(await getDatabasesPath(), 'student.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
        );
      },
    );
  }

  // Insert student
  Future<void> insertStudent(String name) async {
    final dbClient = await db;
    await dbClient.insert('students', {'name': name});
  }

  // Get all students
  Future<List<Map<String, dynamic>>> getStudents() async {
    final dbClient = await db;
    return await dbClient.query('students', orderBy: 'id DESC');
  }
}
