import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../components/picture.dart';
import '../models/node.dart';

class Pix8Tab<T extends NodeModel> extends StatefulWidget {
  NodeModel fractal;
  Pix8Tab(this.fractal, {Key? key}) : super(key: key);

  @override
  State<Pix8Tab> createState() => _Pix8TabState();
}

class _Pix8TabState extends State<Pix8Tab> {
  static const double size = 256;
  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: widget.fractal.refreshed,
        builder: (ctx, val, child) => widget.fractal.image != null
            ? Tab(
                height: widget.fractal.image == null ? null : size,
                child: Column(
                  children: [
                    MediaBlock(
                      /*
              child: Text(
                widget.fractal.title.ifEmpty(
                  () => widget.fractal.name.capitalizeFirst,
                ),
              ),
              */
                      onUpload: (media) {
                        widget.fractal.set({'image': media.id});
                        print(media.id);
                      },
                      size: size,
                    ),
                    Text(
                      widget.fractal.title.ifEmpty(
                        () => widget.fractal.name.capitalizeFirst,
                      ),
                    ),
                    Text(widget.fractal.refreshed.value.toString())
                  ],
                ),
              )
            : Tab(
                icon: MediaBlock(
                  /*
                  child: Text(
                    widget.fractal.title.ifEmpty(
                      () => widget.fractal.name.capitalizeFirst,
                    ),
                  ),
                  */
                  onUpload: (media) {
                    widget.fractal.set({'image': media.id});
                  },
                  size: 32,
                ),
                text: widget.fractal.title.ifEmpty(
                  () => widget.fractal.name.capitalizeFirst,
                ),
              ),
      );
}
