import 'package:flutter/material.dart';
import 'package:fractal_gold/app.dart';
import 'package:fractal_gold/models/app.dart';
import 'package:fractal_gold/models/screen.dart';
import 'package:fractal_gold/screens/pix8.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pix8 = AppFractal(
      id: 'pix8',
      color: Color.fromARGB(255, 0, 204, 0),
      icon: Image.asset('assets/pix8.png'),
      title: 'Pix8',
      hideAppBar: true,
      home: ScreenFractal(
        icon: Icons.picture_in_picture_outlined,
        name: 'pix8',
        builder: Pix8Screen.new,
      ),
      screens: [],
    );
    return FractalApp(pix8);
  }
}
