class DbMigrator {
  static final Map<int, String> migrations = {
    1: '''
      CREATE TABLE "reclamacoes" ("id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, "descricao"	TEXT NOT NULL);
    ''',
    2: '''
      ALTER TABLE "reclamacoes" ADD COLUMN "titulo" TEXT ;
    ''',
    3: '''
      ALTER TABLE "reclamacoes" ADD COLUMN "foto" TEXT ;
    ''',
    4: '''
      ALTER TABLE "reclamacoes" ADD COLUMN "lat" TEXT ;
    ''',
    5: '''
      ALTER TABLE "reclamacoes" ADD COLUMN "lng" TEXT ;
    ''',
  };
}
