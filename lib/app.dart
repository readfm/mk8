import 'package:flutter/material.dart';
import 'package:fractal_gold/auth/fractals/index.dart';
import 'package:fractal_gold/models/app.dart';
import 'package:fractal_gold/screens.dart';

import 'screens.dart';

final ab8app = AppFractal(
  id: 'pix8',
  color: Color.fromARGB(250, 20, 20, 20),
  icon: Image.asset('assets/icon.png'),
  title: 'AB',
  //hideAppBar: true,
  auths: [LocalAuthFractal(), PasswordAuthFractal(), MetamaskAuthFractal()],
  home: thing8Screen,
  /*ScreenFractal(
    icon: Icons.picture_in_picture_outlined,
    name: 'pix8',
    builder: Pix8Screen.new,
  ),*/
  screens: [],
);
