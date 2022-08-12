import 'package:flutter/material.dart';
import 'package:fractal_gold/models/screen.dart';

import 'areas/log.dart';
import 'screens/thing.dart';

final thing8Screen = ScreenFractal(
  name: 'log',
  icon: Icons.chat_bubble_outline_sharp,
  builder: () => AbThingScreen(),
);
