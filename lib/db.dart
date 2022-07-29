import 'dart:io';
import 'package:fractals/models/account.dart';
import 'package:path/path.dart' as path;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fractals/io.dart';
import 'package:path_provider/path_provider.dart';

import '/fractals/log.dart';
import 'fractals/option.dart';

part 'db.g.dart';

MyDatabase get db => MyDatabase.main ??= MyDatabase();

@DriftDatabase(tables: [Logs, Options])
class MyDatabase extends _$MyDatabase {
  static MyDatabase? main;

  // we tell the database where to store the data with this constructor
  MyDatabase() : super(_openConnection()) {
    Acc.db = this;
  }

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder

    print(FIO.documentsPath);
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();

    final file = File(
      path.join(dbFolder.path, 'db.sqlite'),
    );

    //file.deleteSync();

    return NativeDatabase(file, logStatements: true);
  });
}

@UseRowClass(LogFractal)
class Logs extends Table {
  IntColumn get i => integer().autoIncrement()();
  TextColumn get id => text()();
  TextColumn get action => text()();
  TextColumn get thing => text()();
  IntColumn get time => integer()();
}

@UseRowClass(OptionFractal)
class Options extends Table {
  IntColumn get i => integer().autoIncrement()();
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get of => text()();
}
