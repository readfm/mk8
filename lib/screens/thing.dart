import 'package:flutter/material.dart';
import 'package:fractal_gold/screens/fscreen.dart';
import 'package:fractal_gold/widgets/listen.dart';
import 'package:fractal_gold/widgets/sliding.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../fractals/log.dart';

class AbThingScreen extends StatefulWidget {
  LogFractal? fractal;
  AbThingScreen({this.fractal, Key? key}) : super(key: key);

  @override
  State<AbThingScreen> createState() => _AbThingState();
}

class _AbThingState extends State<AbThingScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    thing =
        _controller.text = widget.fractal?.thing.value ?? 'https://twitter.com';
    _animCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
  }

  late final AnimationController _animCtrl;

  late TextEditingController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var showAppBar = true;

  @override
  Widget build(BuildContext context) {
    return widget.fractal != null
        ? Listen(
            widget.fractal!.options.refreshed,
            (ctx, child) => DefaultTabController(
              length: widget.fractal!.options.list.length,
              child: buildScafold(),
            ),
          )
        : buildScafold();
  }

  buildScafold() => Scaffold(
        appBar: showAppBar
            ? SlidingBar(
                controller: _animCtrl,
                visible: showAppBar,
                child: AppBar(
                  title: TextFormField(
                    controller: _controller,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    onFieldSubmitted: (value) => setState(() {
                      thing = _controller.text;
                    }),
                  ),
                  bottom: widget.fractal?.options.list.isBlank! ?? true
                      ? null
                      : TabBar(
                          indicatorWeight: 2,
                          labelColor: Colors.white,
                          tabs: [
                            ...widget.fractal!.options.list.map(
                              (option) => Tab(
                                text: option.title.value,
                              ),
                            )
                          ],
                        ),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: IconButton(
          color: Colors.white,
          padding: EdgeInsets.all(0),
          onPressed: () {
            setState(() {
              showAppBar = !showAppBar;
            });
          },
          icon: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color.fromARGB(205, 255, 255, 255),
            ),
            alignment: Alignment.center,
            child: const Text(
              '8',
              style: TextStyle(
                color: Colors.black,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(child: display()),
      );

  String thing = '';
  Widget display() {
    if (thing.isEmpty) {
      return Container();
    }

    if (thing.isURL) {
      final uri = Uri.parse(thing);
      if (uri.path.isImageFileName) {
        return Image.network(
          thing,
          width: Get.width,
        );
      } else {
        return WebView(
          key: Key(thing),
          initialUrl: thing,
          onPageStarted: (url) {
            _controller.text = url;
          },
          javascriptMode: JavascriptMode.unrestricted,
        );
      }
    } else
      return Container();
  }
}
