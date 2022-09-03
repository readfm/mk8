import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../areas/log.dart';
import '../fractals/log.dart';
import '../screens/thing.dart';

class StringAbBlock extends StatefulWidget {
  LogFractal item;
  StringAbBlock(
    this.item, {
    Key? key,
  }) : super(key: key);

  @override
  State<StringAbBlock> createState() => _StringAbBlockState();
}

class _StringAbBlockState extends State<StringAbBlock> {
  LogFractal get item => widget.item;

  bool editMode = false;
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return buildCell();
  }

  Widget buildCell() {
    return Container(
      child: SwipeActionCell(
        key: ObjectKey(item.id),

        ///this key is necessary
        leadingActions: <SwipeAction>[
          SwipeAction(
            title: item.id,
            onTap: (CompletionHandler handler) async {
              //list.removeAt(index);
              //setState(() {});
            },
            color: Color.fromARGB(200, 54, 54, 54),
          ),
        ],
        trailingActions: [
          SwipeAction(
            title: timeago.format(
                  DateTime.fromMillisecondsSinceEpoch(
                    item.time.value,
                  ),
                  locale: 'en_short',
                ) +
                ' ago',
            onTap: (CompletionHandler handler) async {},
            color: Colors.blue,
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          color: active ? Colors.grey.shade300 : null,
          height: 40,
          child: /*editMode
              ? buildInput()
              : */
              Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  /*
                  setState(() {
                    active = !active;
                  });
                  */

                  Get.to(
                    () => AbThingScreen(
                      fractal: item,
                      key: Key(item.thing.value),
                    ),
                    routeName: item.action.value,
                  );
                },
                /*
                onLongPress: () {
                  setState(() {
                    editMode = !editMode;
                  });
                },
                */
                child: buildContent(),
              ).expand(),
              Text(
                item.time.value.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ).pOnly(right: 4),
            ],
          ),
        ),
      ),
    );
  }

  int selected = 0;
  Widget buildContent() {
    final value = item.action.value.replaceAll(Log8Area.exp, '').trim();
    List<String> options = [];

    Log8Area.exp.allMatches(item.action.value).forEach((match) async {
      options.add(
        match.group(0)!.substring(1).trim(),
      );
    });

    return Container(
      height: double.infinity,
      padding: const EdgeInsets.only(
        top: 1,
        left: 1,
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 16),
      ),
      /*
        const SizedBox(
          width: 4,
        ),
        if (options.isNotEmpty)
          InkWell(
            onTap: () {
              setState(() {
                selected = (selected + 1);
                if (selected >= options.length) selected = 0;
              });
            },
            child: Text(
              options[selected],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
              ),
            ),
          ),
          */
      //].hStack(),
    );
  }

  late final TextEditingController _inputCtrl = TextEditingController()
    ..text = item.action.value;

  Widget buildInput() {
    final value = item.action.value;

    return TextFormField(
      controller: _inputCtrl,
      autofocus: true,
      scrollPadding: const EdgeInsets.all(0),
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(
          top: 16,
          left: 1,
        ),
      ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      onFieldSubmitted: (doc) async {
        item.action.value = _inputCtrl.text;
        setState(() {
          editMode = false;
        });
      },
    );
  }
}
