import 'dart:math';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:fractal_gold/screens/fscreen.dart';
import 'package:fractal_gold/widgets/listen.dart';
import 'package:fractal_gold/widgets/sliding.dart';
import 'package:fractals/extensions/drift.dart';
import 'package:fractals/fracts/bytes.dart';
import 'package:fractals/helpers/random.dart';
import 'package:fractals/models/index.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:mk8/fractals/option.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../areas/log.dart';
import '../areas/wysiwyg.dart';
import '../db.dart';
import '../fractals/log.dart';

import '../db.dart';

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
    _controllerPlay = TextEditingController();
    thing = _controller.text =
        widget.fractal?.thing.value ?? 'https://news.ycombinator.com/';
    if (widget.fractal != null)
      _controllerPlay.text =
          widget.fractal!.action.value.replaceAll(Log8Area.exp, '').trim();

    _animCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    reload();
  }

  reload() {
    final query = db.select(db.options);
    query.where(
      (tbl) => tbl.of.equals(widget.fractal?.id),
    );

    options = CatalogFractal<OptionFractal>(
      id: 'opts',
      select: query,
      type: OptionFractal.w,
    );
  }

  late CatalogFractal<OptionFractal> options;

  late final AnimationController _animCtrl;
  late TextEditingController _controllerPlay;
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
  static double optionsHeight = 200;
  static double optionsMove = 0;

  @override
  Widget build(BuildContext context) {
    return buildScafold();
  }

  /*
  late final options = Log8Area.exp
      .allMatches(widget.fractal!.action.value)
      .map((m) => m.group(0)!.substring(1).trim());
  */

  bool renameMode = false;
  bool listOn = true;

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
        child: [
          if (showAppBar)
            Container(
              height: listOn ? abHeight : optionsHeight + 90,
              child: Stack(
                fit: StackFit.loose,
                children: [
                  [
                    if (widget.fractal != null)
                      Listen(
                          options.refreshed,
                          (ctx, child) => DefaultTabController(
                                length: options.list.length,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    verticalDirection: VerticalDirection.down,
                                    children: [
                                      TabBar(
                                        labelPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        isScrollable: true,
                                        unselectedLabelColor: Colors.grey[400],
                                        labelStyle: TextStyle(
                                            fontSize: optionsHeight / 2),
                                        indicatorWeight: 5,
                                        //indicatorColor: Colors.grey,
                                        labelColor: Colors.black,
                                        indicatorColor:
                                            Theme.of(context).primaryColor,
                                        indicatorPadding: EdgeInsets.zero,
                                        tabs: [
                                          ...options.list.map(
                                            (option) => buildTab(option),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 140,
                                        height: 32,
                                        child: TextFormField(
                                          //controller: ctrl,
                                          style: new TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                          onFieldSubmitted: (value) async {
                                            if (value.trim().isNotBlank) {
                                              final option = OptionFractal(
                                                id: getRandomString(4),
                                                title: value.trim(),
                                                of: widget.fractal!.id,
                                              );
                                              await option.store();
                                              setState(() {
                                                reload();
                                              });
                                            }
                                          },
                                          decoration: const InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    bottom: 8),
                                            prefixIcon: Icon(Icons.add),
                                            hintText: 'new..',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ).expand(),
                                ),
                              )),
                    if (widget.fractal != null)
                      GestureDetector(
                        onVerticalDragUpdate: (details) {
                          if (options.list.isNotEmpty) {
                            setState(() {
                              optionsHeight += details.delta.dy;
                            });
                          }
                        },
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            optionsMove += details.delta.dx;
                          });
                        },
                        onHorizontalDragEnd: (d) {
                          setState(() {
                            if (optionsMove > 20) {
                              listOn = !listOn;
                            }
                            optionsMove = 0;
                          });
                        },
                        onDoubleTapDown: (details) {
                          setState(() {
                            renameMode = true;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(
                            left: 8 + ((optionsMove > 0) ? optionsMove : 0),
                            right: 8 +
                                ((optionsMove < 0) ? (optionsMove * -1) : 0),
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            //readOnly: !renameMode,
                            controller: _controllerPlay,
                            textAlign: TextAlign.center,
                            onFieldSubmitted: (value) {
                              setState(() {
                                renameMode = false;

                                widget.fractal!.action.value = value;
                                (db.update(db.logs)
                                      ..where((t) =>
                                          t.id.equals(widget.fractal!.id)))
                                    .write(
                                  LogsCompanion(
                                    action: Value(value),
                                  ),
                                );
                              });

                              //widget.fractal.attr(name, frac);
                              //widget.fractal!.action.value = value;
                            },
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    if (listOn)
                      Expanded(
                        child: Log8Area(
                          //editMode: editMode,
                          key: Key(widget.fractal != null
                              ? widget.fractal!.action.value
                              : thing),
                          thing: thing,
                        ),
                      ),
                  ].vStack(),

                  //if (showAppBar)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 46,
                      color: Colors.black.withAlpha(
                        250 -
                            [abHeight - defaultHeight, defaultHeight * 2]
                                .reduce(min)
                                .toInt(),
                      ),
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
                ],
              ),
            ),
          display().expand(),
        ].vStack(),
      ),
    );
  }

  buildTab(OptionFractal option) {
    final t = option.title.value;
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = new RegExp(pattern);
    return (regExp.hasMatch(t))
        ? Tab(
            child: Image.network(t),
            height: optionsHeight,
          )
        : Tab(
            text: option.title.value,
            height: optionsHeight,
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
        final slashPos = doc.indexOf('/');
        final action = slashPos == -1 ? doc : doc.substring(0, slashPos);
        final id = getRandomString(4);
        final log = LogFractal(
          action: action,
          id: id,
          time: DateTime.now().millisecondsSinceEpoch,
          thing: url,
        );

        await log.store();
        log.sync();

        List<String> args = doc.substring(slashPos + 1).split('/');

        for (final a in args) {
          final option = OptionFractal(
            id: getRandomString(4),
            of: id,
            title: a.trim(),
          )..sync();
          await option.store();
        }

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
    } else if (thing.startsWith('mk8://')) {
      final name = thing.substring(6);
      return WysiwygInput(
        name: name,
        key: Key(name),
      );
    } else if (thing.isURL) {
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
