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
    /*
      ..where(
        (tbl) => tbl.thing.equals(widget.thing),
      );*/

    catalog = CatalogFractal<LogFractal>(
      id: 'msgs',
      select: query,
      type: LogFractal.w,
    );
    super.initState();
    controller = SwipeActionController();

    _inputCtrl = TextEditingController();

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
        VStack([
      buildInput(),
      Expanded(
        child: Listen(
          catalog.refreshed,
          (ctx, child) => VStack([
            Expanded(
              child: ReorderableListView.builder(
                key: Key('list'),
                buildDefaultDragHandles: false,
                onReorder: (oldIndex, newIndex) {},
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                shrinkWrap: true,
                itemBuilder: (c, index) => StringAbBlock(
                  catalog.list[index],
                  key: Key(
                    index.toString(),
                  ),
                ),
                itemCount: catalog.list.length,
              ),
            ),
          ]),
        ),
      ),
    ]) /*,
      ),
    )*/
        ;
  }

  late TextEditingController _inputCtrl;

  buildInput() => TextFormField(
        controller: _inputCtrl,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'ab',
          contentPadding: EdgeInsets.all(8),
        ),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        onFieldSubmitted: (doc) async {
          /*
          final i1 = doc.indexOf('('), i2 = doc.lastIndexOf(')');
          final text =
              (i1 == -1 ? doc.split(' ')[0] : doc.substring(0, i1)).trim();

          List<String> args =
              (i1 != -1 && i2 > i1) ? doc.substring(i1 + 1, i2).split('|') : [];

          final thing = i1 == -1
              ? (text.length < doc.length
                  ? doc.substring(text.length + 1).trim()
                  : widget.thing)
              : ((i2 > i1) ? doc.substring(i2 + 1).trim() : '');
            */

          final id = getRandomString(4);
          final log = LogFractal(
            action: doc,
            id: id,
            time: DateTime.now().millisecondsSinceEpoch,
            thing: widget.thing,
          );

          await log.store();
          log.sync();

          Log8Area.exp.allMatches(doc).forEach((match) async {
            final opt = match.group(0)!.substring(1).trim();

            final option = OptionFractal(
              id: getRandomString(4),
              of: id,
              title: opt,
            )..sync();
            await option.store();
          });

          catalog.refresh();

          _inputCtrl.clear();

          //f.sync();
        },
      );

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
