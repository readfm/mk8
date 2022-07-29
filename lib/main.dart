import '/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fractal_gold/dex.dart';
import 'package:fractal_gold/layouts/fractal.dart';
import 'package:fractal_gold/models/app.dart';
import 'package:fractal_gold/schema.dart';
import 'package:fractal_gold/ui.dart';
import 'package:fractals/io.dart';
import 'package:fractals/models/account.dart';
import 'package:fractals/models/fractal.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:universal_io/io.dart';

import 'app.dart';
import 'layouts/ab.dart';

Map<String, AppFractal> sites = {};

void main() async {
  Dex.ipfs;

  await Hive.initFlutter('HiveFStorage');
  for (final site in []) {}
  await define();

  await FractalUI.init();
  //FIO.documentsPath = '/Users/mk/Data/Documents';

  //call dalle api to get the list of sites

  await Fractal.init();
  if (!(Platform.isMacOS || Platform.isIOS)) {
    Acc.storageAlt = const FlutterSecureStorage();
  }

  runApp(XIApp());
}

class XIApp extends StatefulWidget {
  XIApp({Key? key}) : super(key: key);

  @override
  State<XIApp> createState() => _XIAppState();
}

class _XIAppState extends State<XIApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Acc.connect();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbLayout(ab8app);
  }
}
