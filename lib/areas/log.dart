import 'package:fractals/extensions/drift.dart';
import 'package:fractals/models/catalog.dart';
import '../blocks/string.dart';
import '/fractals/option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:fractal_gold/widgets/listen.dart';
import 'package:fractals/communication.dart';
import 'package:fractals/fracts/bytes.dart';
import 'package:fractals/helpers/random.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:drift/drift.dart';
import '../db.dart';
import '../fractals/log.dart';

class Log8Area extends StatefulWidget {
  String thing;
  Log8Area({
    Key? key,
    this.thing = '',
  }) : super(key: key);

  static final exp = new RegExp(r"/+([a-zA-Z0-9_]+)");

  @override
  State<Log8Area> createState() => _Log8AreaState();
}

class _Log8AreaState extends State<Log8Area> {
  /// To controller edit mode
  late SwipeActionController controller;

  List<LogFractal> list = [];

  bool humanTime = false;
  bool editMode = false;

  late CatalogFractal<LogFractal> catalog;

  ///在initState
  @override
  void initState() {
    final query = db.select(db.logs)
      ..orderBy([
        (t) => OrderingTerm(
              expression: t.time,
              mode: OrderingMode.desc,
            )
      ]);

    if (widget.thing[0] == '.') {
      query.where(
        (tbl) => tbl.action.like(
          '%' + widget.thing.substring(1) + '%',
        ),
      );
    }

    catalog = CatalogFractal<LogFractal>(
      id: 'msgs',
      select: query,
      type: LogFractal.w,
    );
    super.initState();
    controller = SwipeActionController();

    /*
    catalog.refreshed.listen((_) {
      setState(() {
        list = catalog.list.reversed.toList();
      });
    });
    */
  }

  //Table table;

  @override
  Widget build(BuildContext context) {
    return /*FScreen(
      Scaffold(
        appBar: null,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            humanTime ? Icons.punch_clock : Icons.timelapse,
          ),
          onPressed: () {
            setState(() {
              humanTime = !humanTime;
            });
          },
        ),
        body: */
        Listen(
      catalog.refreshed,
      (ctx, child) => ReorderableListView.builder(
        key: const Key('list'),
        buildDefaultDragHandles: false,
        onReorder: (oldIndex, newIndex) {},
        shrinkWrap: true,
        itemBuilder: (c, index) => StringAbBlock(
          catalog.list[index],
          key: Key(
            index.toString(),
          ),
        ),
        itemCount: catalog.list.length,
      ),
    );
  }

  Widget _getIconButton(color, icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),

        ///set you real bg color in your content
        color: color,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    Communication.catalog.dispose();
    super.dispose();
  }
}
