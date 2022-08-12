import 'package:flutter/material.dart';
import 'package:fractal_gold/screens/fscreen.dart';
import 'package:fractal_gold/widgets/listen.dart';
import 'package:fractal_gold/widgets/sliding.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../areas/log.dart';
import '../db.dart';
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
    thing = _controller.text =
        widget.fractal?.thing.value ?? 'https://news.ycombinator.com/';
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

  static double abHeight = 10;

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
        appBar: null,
        /*showAppBar
            ? SlidingBar(
                controller: _animCtrl,
                visible: showAppBar,
                child: AppBar(
                  title: Text('ok'),
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
            : null,*/
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        floatingActionButton: showAppBar
            ? null
            : IconButton(
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
        body: SafeArea(
          child: Column(children: [
            if (showAppBar && abHeight > 30)
              Container(
                height: abHeight,
                child: Log8Area(
                  thing: thing,
                ),
              ),
            /*
            if (!editMode &&
                widget.fractal != null &&
                widget.fractal!.options.list.isNotEmpty)
              TabBar(
                indicatorWeight: 3,
                labelColor: Colors.black,
                tabs: [
                  ...widget.fractal!.options.list.map(
                    (option) => Tab(
                      text: option.title.value,
                    ),
                  )
                ],
              ),
            if (!editMode)
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('PLAY'),
                ),
              ),
            */
            if (showAppBar)
              Container(
                height: 50,
                color: Colors.black,
                child: Row(children: [
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        abHeight += details.delta.dy;
                      });
                    },
                    onDoubleTap: () {
                      setState(() {
                        showAppBar = !showAppBar;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextFormField(
                        controller: _controller,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                        onFieldSubmitted: refresh,
                      ),
                      height: 48,
                    ),
                  ).expand(),
                ]),
              ),
            display().expand(),
          ]),
        ),
      );

  refresh([val]) async {
    final txt = _controller.text;
    if (txt.contains('://')) {
      setState(() {
        thing = txt;
      });
    } else if (txt.length == 4) {
      final query = db.select(db.logs)
        ..where(
          (tbl) => tbl.id.equals(txt),
        );
      final list = await query.get();
      if (list.isNotEmpty) {
        setState(() {
          widget.fractal = list[0];
          thing = widget.fractal!.thing.value;
        });
      }
    }
  }

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
          navigationDelegate: (navigation) {
            _controller.text = navigation.url;
            return NavigationDecision.navigate;
          },
          onPageStarted: (url) {
            _controller.text = url;
            refresh();
          },
          javascriptMode: JavascriptMode.unrestricted,
        );
      }
    } else
      return Container();
  }
}
