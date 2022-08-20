import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fractal_gold/screens/fscreen.dart';
import 'package:fractal_gold/widgets/listen.dart';
import 'package:fractal_gold/widgets/sliding.dart';
import 'package:fractals/extensions/drift.dart';
import 'package:fractals/fracts/bytes.dart';
import 'package:fractals/helpers/random.dart';
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

  bool get showAppBar => abHeight >= defaultHeight;
  static const defaultHeight = 40.0;
  bool editMode = true;

  static double abHeight = defaultHeight;
  static double optionsHeight = 300;

  @override
  Widget build(BuildContext context) {
    return widget.fractal != null
        ? Listen(
            widget.fractal!.options.refreshed,
            (ctx, child) => DefaultTabController(
              length: options.length,
              child: buildScafold(),
            ),
          )
        : buildScafold();
  }

  late final options = Log8Area.exp
      .allMatches(widget.fractal!.action.value)
      .map((m) => m.group(0)!.substring(1).trim());

  late final title =
      widget.fractal!.action.value.replaceAll(Log8Area.exp, '').trim();

  buildScafold() {
    return Scaffold(
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
                  abHeight = defaultHeight;
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
          if (showAppBar)
            Container(
              height: abHeight,
              child: Stack(
                fit: StackFit.loose,
                children: [
                  Column(
                    children: [
                      if (widget.fractal != null && options.isNotEmpty)
                        TabBar(
                          indicatorWeight: 5,
                          isScrollable: true,
                          indicatorColor: Colors.grey,
                          labelColor: Colors.black,
                          labelStyle: TextStyle(fontSize: optionsHeight / 2),
                          tabs: [
                            ...options.map(
                              (option) => Tab(
                                text: option,
                                height: optionsHeight,
                              ),
                            )
                          ],
                        ),
                      if (widget.fractal != null)
                        GestureDetector(
                          onVerticalDragUpdate: (details) {
                            if (options.isNotEmpty)
                              setState(() {
                                optionsHeight += details.delta.dy;
                              });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Log8Area(
                          //editMode: editMode,
                          key: Key(widget.fractal != null
                              ? widget.fractal!.action.value
                              : thing),
                          thing: thing,
                        ),
                      ),
                    ],
                  ),

                  //if (showAppBar)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 46,
                      color: Colors.black.withAlpha(250 -
                          [abHeight - defaultHeight, defaultHeight * 2]
                              .reduce(min)
                              .toInt()),
                      child: GestureDetector(
                        onVerticalDragUpdate: (details) {
                          setState(() {
                            abHeight += details.delta.dy;
                          });
                        },
                        onDoubleTap: () {
                          setState(() {
                            abHeight = showAppBar ? 0 : defaultHeight;
                          });
                        },
                        child: Container(
                          height: 48,
                          child: TextFormField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 8),
                            ),
                            controller: _controller,
                            cursorColor: Colors.white,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            onFieldSubmitted: submit,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          display().expand(),
        ]),
      ),
    );
  }

  submit([val]) async {
    final txt = _controller.text;
    final words = txt.split(' ');

    if (words.isNotEmpty && txt.startsWith('.')) {
      final doc = txt.substring(1);

      setState(() {
        thing = txt;
      });
      /*
      Get.to(
        () => AbThingScreen(
          thing: txt,
          key: Key(item.thing.value),
        ),
        routeName: txt,
      );
      */
    } else if (words.last.contains('://')) {
      final url = words.removeLast();
      final doc = words.join(' ');

      if (words.isNotEmpty) {
        final id = getRandomString(4);
        final log = LogFractal(
          action: doc,
          id: id,
          time: DateTime.now().millisecondsSinceEpoch,
          thing: url,
        );

        await log.store();
        log.sync();

        setState(() {
          widget.fractal = log;
        });
      } else {
        setState(() {
          widget.fractal = null;
          thing = url;
        });
      }
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
          /*
          navigationDelegate: (navigation) {
            _controller.text = navigation.url;
            return NavigationDecision.navigate;
          },
          */
          onPageStarted: (url) {
            if (widget.fractal?.thing.value != url) _controller.text = url;
            //submit();
          },
          javascriptMode: JavascriptMode.unrestricted,
        );
      }
    } else
      return Container();
  }
}
