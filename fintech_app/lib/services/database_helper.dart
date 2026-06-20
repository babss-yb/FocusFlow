/// Helper SQLite pour la persistance locale des données.
/// Préparé pour stocker les transactions, l'utilisateur et les préférences.
///
/// Utilisation :
///   final db = await DatabaseHelper.instance.database;
///   await db.insert('transactions', transaction.toMap());
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  // Database? _database; // Décommenter quand sqflite est disponible

  DatabaseHelper._init();

  // ─── Initialisation ───────────────────────────────────────────────
  // Future<Database> get database async {
  //   if (_database != null) return _database!;
  //   _database = await _initDB('fintech_pme.db');
  //   return _database!;
  // }

  // Future<Database> _initDB(String filePath) async {
  //   final dbPath = await getDatabasesPath();
  //   final path = join(dbPath, filePath);
  //   return openDatabase(path, version: 1, onCreate: _createDB);
  // }

  // ─── Création des tables ──────────────────────────────────────────
  // Future<void> _createDB(Database db, int version) async {
  //   await db.execute('''
  //     CREATE TABLE users (
  //       id TEXT PRIMARY KEY,
  //       firstName TEXT NOT NULL,
  //       lastName TEXT NOT NULL,
  //       email TEXT NOT NULL,
  //       phone TEXT NOT NULL,
  //       companyName TEXT,
  //       companyType TEXT,
  //       avatarUrl TEXT,
  //       isVerified INTEGER DEFAULT 0,
  //       createdAt TEXT NOT NULL,
  //       referralCode TEXT
  //     )
  //   ''');

  //   await db.execute('''
  //     CREATE TABLE transactions (
  //       id TEXT PRIMARY KEY,
  //       title TEXT NOT NULL,
  //       description TEXT,
  //       amount REAL NOT NULL,
  //       date TEXT NOT NULL,
  //       type TEXT NOT NULL,
  //       status TEXT NOT NULL,
  //       recipientName TEXT,
  //       recipientAccount TEXT,
  //       reference TEXT,
  //       category TEXT
  //     )
  //   ''');

  //   await db.execute('''
  //     CREATE TABLE preferences (
  //       key TEXT PRIMARY KEY,
  //       value TEXT NOT NULL
  //     )
  //   ''');
  // }

  // ─── CRUD Transactions ────────────────────────────────────────────
  // Future<int> insertTransaction(Map<String, dynamic> data) async {
  //   final db = await database;
  //   return db.insert('transactions', data);
  // }

  // Future<List<Map<String, dynamic>>> getTransactions() async {
  //   final db = await database;
  //   return db.query('transactions', orderBy: 'date DESC');
  // }

  // Future<int> updateTransaction(String id, Map<String, dynamic> data) async {
  //   final db = await database;
  //   return db.update('transactions', data, where: 'id = ?', whereArgs: [id]);
  // }

  // Future<int> deleteTransaction(String id) async {
  //   final db = await database;
  //   return db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  // }

  // ─── CRUD Utilisateur ─────────────────────────────────────────────
  // Future<int> insertUser(Map<String, dynamic> data) async {
  //   final db = await database;
  //   return db.insert('users', data, conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  // Future<Map<String, dynamic>?> getUser(String id) async {
  //   final db = await database;
  //   final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
  //   return result.isNotEmpty ? result.first : null;
  // }

  // ─── Préférences ──────────────────────────────────────────────────
  // Future<void> setPreference(String key, String value) async {
  //   final db = await database;
  //   await db.insert('preferences', {'key': key, 'value': value},
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  // Future<String?> getPreference(String key) async {
  //   final db = await database;
  //   final result = await db.query('preferences', where: 'key = ?', whereArgs: [key]);
  //   return result.isNotEmpty ? result.first['value'] as String : null;
  // }
}
