import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'db_mitrator.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  DatabaseHelper._createInstance(); // Construtor nomeado para criar instância do DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // Isso é executado apenas uma vez, objeto singleton
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDB();
    }
    return _database;
  }

  Future<Database> openDatabase(String path,
      {int version,
      OnDatabaseConfigureFn onConfigure,
      OnDatabaseCreateFn onCreate,
      OnDatabaseVersionChangeFn onUpgrade,
      OnDatabaseVersionChangeFn onDowngrade,
      OnDatabaseOpenFn onOpen,
      bool readOnly = false,
      bool singleInstance = true}) {
    final OpenDatabaseOptions options = OpenDatabaseOptions(
        version: version,
        onConfigure: onConfigure,
        onCreate: onCreate,
        onUpgrade: onUpgrade,
        onDowngrade: onDowngrade,
        onOpen: onOpen,
        readOnly: readOnly,
        singleInstance: singleInstance);
    return databaseFactory.openDatabase(path, options: options);
  }

  Future<Database> initDB() async {
    // obtem caminho do banco de dados
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'dedo-duro.db';

    // obtem o número máximo da versão da migração
    var maxMigratedDbVersion = DbMigrator.migrations.keys.reduce(max);

    return await openDatabase(path,
        version: maxMigratedDbVersion,
        onOpen: (db) {},
        onCreate: _onCreate,
        onUpgrade: _onUpgrade);
  }

  Future<void> _onCreate(Database db, int _) async {
    // executa todas as migrações se estiver criando o banco de dados pela primeira vez
    DbMigrator.migrations.keys.toList()
      ..sort()
      ..forEach((k) async {
        var script = DbMigrator.migrations[k];
        await db.execute(script);
      });
  }

  Future<void> _onUpgrade(Database db, int _, int __) async {
    // obtém a versão do banco de dados atual
    var curdDbVersion = await getCurrentDbVersion(db);
    // obtem o número máximo da versão da migração
    var maxMigratedDbVersion = DbMigrator.migrations.keys.reduce(max);
    // obtém apenas os scripts de migração cujo número é maior que o número da versão atual do banco de dados
    var upgradeScripts = new Map.fromIterable(
        DbMigrator.migrations.keys.where((k) => k > curdDbVersion),
        key: (k) => k,
        value: (k) => DbMigrator.migrations[k]);

    if (upgradeScripts.length == 0) return;

    upgradeScripts.keys.toList()
      ..sort()
      ..forEach((k) async {
        var script = upgradeScripts[k];
        await db.execute(script);
      });

    // Depois que todos os scripts forem executados, precisamos garantir que a versão do banco de dados seja atualizada
    _upgradeDbVersion(db, maxMigratedDbVersion);
  }

  _upgradeDbVersion(Database db, int version) async {
    await db.rawQuery("pragma user_version = $version;");
  }

  Future<int> getCurrentDbVersion(Database db) async {
    var res = await db.rawQuery('PRAGMA user_version;', null);
    var version = res[0]["user_version"].toString();
    return int.parse(version);
  }
}
