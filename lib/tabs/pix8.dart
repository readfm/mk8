import 'package:flutter/material.dart';
import 'package:fractal_gold/blocks/image.dart';

import '../models/image.dart';

class Pix8Tab extends StatelessWidget {
  final ImageFractal fractal;
  const Pix8Tab(this.fractal, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 300,
      iconMargin: EdgeInsets.zero,
      child: FractalImage(fractal),
    );
  }
}
