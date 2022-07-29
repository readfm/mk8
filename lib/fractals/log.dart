import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/src/runtime/query_builder/query_builder.dart';
import 'package:drift/src/dsl/dsl.dart';
import 'package:frac/frac.dart';
import 'package:fractal_socket/session.dart';
import 'package:fractal_socket/socket.dart';
import 'package:fractal_word/word.dart';
import 'package:fractals/extensions/drift.dart';
import 'package:fractals/extensions/word.dart';
import 'package:fractals/fracts/bytes.dart';
import 'package:fractals/models/catalog.dart';
import 'package:fractals/models/created.dart';
import 'package:fractals/models/fractal.dart';
import 'package:fractals/models/message.dart';

import '../db.dart';
import 'option.dart';

const ts = String;

/*
class LogFractal extends Message implements FractalSocketAbs {
  final text = Frac<String>('');
  final of = Frac<String>('');
  List<OptionFractal> options = [];
  String get message => text.value;

  String thing = '';

  @override
  get word => w;
  static final w = Word('log')..fractal = ([m]) => LogFractal.xi(m);

  LogFractal({
    super.name,
    super.text,
    //this.thing = '',
    //this.options = const [],
    required super.id,
  }) : super();

  factory LogFractal.xi([x]) => x is Map
      ? LogFractal(
          name: '',
          text: x['text'] ?? '',
          id: x['id'] ?? '',
        )
      : LogFractal(
          name: '',
          text: '',
          id: x,
        );

  @override
  handle(FractalSocket socket) {
    socket;
  }
}

*/

class LogFractal extends Fractal {
  LogFractal({
    String id = '',
    String action = '',
    String thing = '',
    int time = 0,
  }) : super(id) {
    this['action'] = this.action..value = action;
    this['thing'] = this.thing..value = thing;
    this['time'] = this.time..value = time;

    final query = db.select(db.options)..where((tbl) => tbl.of.equals(id));
    options = CatalogFractal<OptionFractal>(
      id: id + '_options',
      select: query,
      type: LogFractal.w,
    );
  }

  late CatalogFractal<OptionFractal> options;

  static final w = Word('log');

  final action = Frac<String>('');

  final thing = Frac<String>('');
  final time = Frac<int>(0);

  @override
  get word => w;
}
