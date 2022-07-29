// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class LogsCompanion extends UpdateCompanion<LogFractal> {
  final Value<int> i;
  final Value<String> id;
  final Value<String> action;
  final Value<String> thing;
  final Value<int> time;
  const LogsCompanion({
    this.i = const Value.absent(),
    this.id = const Value.absent(),
    this.action = const Value.absent(),
    this.thing = const Value.absent(),
    this.time = const Value.absent(),
  });
  LogsCompanion.insert({
    this.i = const Value.absent(),
    required String id,
    required String action,
    required String thing,
    required int time,
  })  : id = Value(id),
        action = Value(action),
        thing = Value(thing),
        time = Value(time);
  static Insertable<LogFractal> custom({
    Expression<int>? i,
    Expression<String>? id,
    Expression<String>? action,
    Expression<String>? thing,
    Expression<int>? time,
  }) {
    return RawValuesInsertable({
      if (i != null) 'i': i,
      if (id != null) 'id': id,
      if (action != null) 'action': action,
      if (thing != null) 'thing': thing,
      if (time != null) 'time': time,
    });
  }

  LogsCompanion copyWith(
      {Value<int>? i,
      Value<String>? id,
      Value<String>? action,
      Value<String>? thing,
      Value<int>? time}) {
    return LogsCompanion(
      i: i ?? this.i,
      id: id ?? this.id,
      action: action ?? this.action,
      thing: thing ?? this.thing,
      time: time ?? this.time,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (i.present) {
      map['i'] = Variable<int>(i.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (thing.present) {
      map['thing'] = Variable<String>(thing.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogsCompanion(')
          ..write('i: $i, ')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('thing: $thing, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }
}

class $LogsTable extends Logs with TableInfo<$LogsTable, LogFractal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LogsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _iMeta = const VerificationMeta('i');
  @override
  late final GeneratedColumn<int?> i = GeneratedColumn<int?>(
      'i', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String?> action = GeneratedColumn<String?>(
      'action', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _thingMeta = const VerificationMeta('thing');
  @override
  late final GeneratedColumn<String?> thing = GeneratedColumn<String?>(
      'thing', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<int?> time = GeneratedColumn<int?>(
      'time', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [i, id, action, thing, time];
  @override
  String get aliasedName => _alias ?? 'logs';
  @override
  String get actualTableName => 'logs';
  @override
  VerificationContext validateIntegrity(Insertable<LogFractal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('i')) {
      context.handle(_iMeta, i.isAcceptableOrUnknown(data['i']!, _iMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('thing')) {
      context.handle(
          _thingMeta, thing.isAcceptableOrUnknown(data['thing']!, _thingMeta));
    } else if (isInserting) {
      context.missing(_thingMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {i};
  @override
  LogFractal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LogFractal(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      action: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}action'])!,
      thing: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}thing'])!,
      time: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}time'])!,
    );
  }

  @override
  $LogsTable createAlias(String alias) {
    return $LogsTable(attachedDatabase, alias);
  }
}

class OptionsCompanion extends UpdateCompanion<OptionFractal> {
  final Value<int> i;
  final Value<String> id;
  final Value<String> title;
  final Value<String> of;
  const OptionsCompanion({
    this.i = const Value.absent(),
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.of = const Value.absent(),
  });
  OptionsCompanion.insert({
    this.i = const Value.absent(),
    required String id,
    required String title,
    required String of,
  })  : id = Value(id),
        title = Value(title),
        of = Value(of);
  static Insertable<OptionFractal> custom({
    Expression<int>? i,
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? of,
  }) {
    return RawValuesInsertable({
      if (i != null) 'i': i,
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (of != null) 'of': of,
    });
  }

  OptionsCompanion copyWith(
      {Value<int>? i,
      Value<String>? id,
      Value<String>? title,
      Value<String>? of}) {
    return OptionsCompanion(
      i: i ?? this.i,
      id: id ?? this.id,
      title: title ?? this.title,
      of: of ?? this.of,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (i.present) {
      map['i'] = Variable<int>(i.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (of.present) {
      map['of'] = Variable<String>(of.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OptionsCompanion(')
          ..write('i: $i, ')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('of: $of')
          ..write(')'))
        .toString();
  }
}

class $OptionsTable extends Options
    with TableInfo<$OptionsTable, OptionFractal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OptionsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _iMeta = const VerificationMeta('i');
  @override
  late final GeneratedColumn<int?> i = GeneratedColumn<int?>(
      'i', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _ofMeta = const VerificationMeta('of');
  @override
  late final GeneratedColumn<String?> of = GeneratedColumn<String?>(
      'of', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [i, id, title, of];
  @override
  String get aliasedName => _alias ?? 'options';
  @override
  String get actualTableName => 'options';
  @override
  VerificationContext validateIntegrity(Insertable<OptionFractal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('i')) {
      context.handle(_iMeta, i.isAcceptableOrUnknown(data['i']!, _iMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('of')) {
      context.handle(_ofMeta, of.isAcceptableOrUnknown(data['of']!, _ofMeta));
    } else if (isInserting) {
      context.missing(_ofMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {i};
  @override
  OptionFractal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OptionFractal(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      of: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}of'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
    );
  }

  @override
  $OptionsTable createAlias(String alias) {
    return $OptionsTable(attachedDatabase, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $LogsTable logs = $LogsTable(this);
  late final $OptionsTable options = $OptionsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [logs, options];
}
