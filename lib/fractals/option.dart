import 'dart:convert';
import 'dart:typed_data';

import 'package:frac/frac.dart';
import 'package:fractal_socket/session.dart';
import 'package:fractal_socket/socket.dart';
import 'package:fractal_word/word.dart';
import 'package:fractals/extensions/word.dart';
import 'package:fractals/fracts/bytes.dart';
import 'package:fractals/models/created.dart';
import 'package:fractals/models/index.dart';
import 'package:fractals/models/message.dart';

const ts = String;

class OptionFractal extends Fractal {
  final title = Frac<String>('');
  final of = Frac<String>('');

  static final w = Word('option');

  @override
  get word => w;

  OptionFractal({
    String id = '',
    String of = '',
    String title = '',
  }) : super(id) {
    this['title'] = this.title..value = title;
    this['of'] = this.of..value = of;
  }
}
