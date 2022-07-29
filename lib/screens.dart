import 'package:flutter/material.dart';
import 'package:fractal_gold/models/screen.dart';

import 'areas/log.dart';
import 'screens/thing.dart';

final log8Screen = ScreenFractal(
  name: 'log',
  icon: Icons.chat_bubble_outline_sharp,
  builder: () => Log8Screen(key: const Key('logScreen')),
);

final thing8Screen = ScreenFractal(
  name: 'log',
  icon: Icons.chat_bubble_outline_sharp,
  builder: () => AbThingScreen(),
);
