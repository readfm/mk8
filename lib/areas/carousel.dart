import 'package:flutter/material.dart';
import '../filters/objectdb.dart';
import '../models/image.dart';
import '../tabs/pix8.dart';
import 'tabs.dart';

class CarouselArea extends StatefulWidget {
  final String id;
  const CarouselArea(
    this.id, {
    Key? key,
  }) : super(key: key);

  @override
  State<CarouselArea> createState() => _CarouselAreaState();
}

class _CarouselAreaState extends State<CarouselArea> {
  @override
  Widget build(BuildContext context) {
    return TabsArea<ImageFractal>(
      filter: ObjectDBFilter<ImageFractal>({'parent_id': widget.id}),
      tabBuilder: (fractal) => Pix8Tab(fractal),
      builder: (f) => CarouselArea(f.id),
    );
  }
}
