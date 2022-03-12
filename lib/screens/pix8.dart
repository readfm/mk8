import 'package:flutter/material.dart';
import 'package:fractal_gold/areas/carousel.dart';
import 'package:fractal_gold/areas/tabs.dart';
import 'package:fractal_gold/inputs/wysiwyg.dart';
import 'package:provider/provider.dart';

import '../models/app.dart';
import '../models/document.dart';
import '../models/message.dart';
import '../models/node.dart';
import '../models/screen.dart';
import '../slides/testimonials.dart';
import 'fscreen.dart';

class Pix8Screen extends StatefulWidget {
  ScreenFractal screen;
  Pix8Screen(this.screen, {Key? key}) : super(key: key);

  @override
  State<Pix8Screen> createState() => _Pix8ScreenState();
}

class _Pix8ScreenState extends State<Pix8Screen> {
  //final post = Message();
  @override
  Widget build(BuildContext context) {
    return Consumer<AppFractal>(
      builder: (context, app, child) => CarouselArea(app.id),
    );
    /*
    return TabBarView(
      //physics: BouncingScrollPhysics(),
      children: slides,
    );
    */
  }
}
