import 'package:fractal_socket/events/query.dart';
import 'package:fractal_word/word.dart';
import 'package:fractals/extensions/drift.dart';
import 'package:fractals/models/catalog.dart';
import 'package:reorderables/reorderables.dart';
import '/fractals/option.dart';
import '/screens/thing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:fractal_gold/inputs/string.dart';
import 'package:fractal_gold/screens/index.dart';
import 'package:fractal_gold/widgets/listen.dart';
import 'package:fractals/communication.dart';
import 'package:fractals/fracts/bytes.dart';
import 'package:fractals/helpers/random.dart';
import 'package:fractals/models/catalog.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:drift/drift.dart';
import '../db.dart';
import '../fractals/log.dart';
import 'package:reorderables/reorderables.dart';

class Log8Screen extends StatefulWidget {
  Log8Screen({Key? key}) : super(key: key);

  @override
  State<Log8Screen> createState() => _Log8ScreenState();
}

class _Log8ScreenState extends State<Log8Screen> {
  /// To controller edit mode
  late SwipeActionController controller;

  List<LogFractal> list = [];

  bool humanTime = false;

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
        VStack([
      SizedBox(height: 20),
      buildInput(),
      Expanded(
        child: Listen(
          catalog.refreshed,
          (ctx, child) => VStack([
            Expanded(
              child: ReorderableListView.builder(
                onReorder: (oldIndex, newIndex) {},
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                shrinkWrap: true,
                itemBuilder: (c, index) => _buildString(index),
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

  buildInput() => StringInput(
        hint: 'A or B?',
        onSave: (doc) async {
          final i1 = doc.indexOf('('), i2 = doc.lastIndexOf(')');
          final text =
              (i1 == -1 ? doc.split(' ')[0] : doc.substring(0, i1)).trim();

          List<String> args =
              (i1 != -1 && i2 > i1) ? doc.substring(i1 + 1, i2).split('|') : [];

          final id = getRandomString(4);
          final log = LogFractal(
            action: text,
            id: id,
            time: DateTime.now().millisecondsSinceEpoch,
            thing: i1 == -1
                ? doc.substring(text.length + 1).trim()
                : ((i2 > i1) ? doc.substring(i2 + 1).trim() : ''),
          );

          await log.store();
          log.sync();

          for (final a in args) {
            final option = OptionFractal(
              id: getRandomString(4),
              of: id,
              title: a.trim(),
            )..sync();
            await option.store();
          }

          catalog.refresh();

          //f.sync();
        },
      );

  Widget _buildString(int index) {
    final item = catalog.list[index];
    return Container(
      key: Key('abRow$index'),
      height: 40,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Get.to(
                  AbThingScreen(fractal: item),
                );
              },
              child: Container(
                height: 40,
                child: Text(
                  item.action.value,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ).expand(),
            humanTime
                ? Text(
                    timeago.format(
                      DateTime.fromMillisecondsSinceEpoch(
                        item.time.value,
                      ),
                      locale: 'en_short',
                    ),
                  ).pOnly(right: 30)
                : Text(
                    item.time.value.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ).pOnly(right: 30),
          ],
        ),
      ),
    );
  }

  Widget _item(int index) {
    final item = list[index];
    return SwipeActionCell(
        controller: controller,

        ///index is required if you want to enter edit mode
        index: index,
        key: ValueKey(list[index]),
        leadingActions: [
          SwipeAction(
            color: Colors.green,
            icon: Icon(Icons.image),
            onTap: (g) {},
          ),
          SwipeAction(
            nestedAction: SwipeNestedAction(
              ///customize your nested action content

              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(255, 234, 216, 17),
                ),
                width: 130,
                height: 60,
                child: OverflowBox(
                  maxWidth: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      Text('Act',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ),

            ///you should set the default  bg color to transparent
            color: Colors.transparent,

            ///set content instead of title of icon
            content: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),

                ///set you real bg color in your content
                color: Colors.orange,
              ),
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
            onTap: (handler) async {
              list.removeAt(index);
              setState(() {});
            },
          ),
        ],
        trailingActions: [
          SwipeAction(
            nestedAction: SwipeNestedAction(
              ///customize your nested action content

              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.red,
                ),
                width: 130,
                height: 60,
                child: OverflowBox(
                  maxWidth: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      Text('Remove?',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ),

            ///you should set the default  bg color to transparent
            color: Colors.transparent,

            ///set content instead of title of icon
            content: _getIconButton(Colors.red, Icons.delete),
            onTap: (handler) async {
              list.removeAt(index);
              setState(() {});
            },
          ),
          /*
        SwipeAction(
          content: VStack([
            Text(
              timeago.format(
                item.createdAt,
                locale: 'en_short',
              ),
            ),
            Text(
              item.id,
              style: TextStyle(fontSize: 18),
            ),
          ]),
          color: Colors.transparent,
          onTap: (handler) {},
        ),
        */
        ],
        child: _buildString(index)
        /*
              Container(
                child: Text(
                  item.createdAt.millisecondsSinceEpoch.toString(),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              */ /* Column(children: [
            .expand(),
            Container(
              child: Text(
                item.createdAt.millisecondsSinceEpoch.toString(),
                style: TextStyle(fontSize: 18),
              ),
              width: 500,
            ),
          ]),*/
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
