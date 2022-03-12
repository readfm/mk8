import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:fractal_gold/models/document.dart';
import 'package:get/get.dart';

import 'package:velocity_x/velocity_x.dart';
import '../components/tab_indicator.dart';
import '../filters/objectdb.dart';
import '../models/image.dart';
import '../models/node.dart';
import '../models/xi.dart';

class TabsArea<T extends NodeModel> extends StatelessWidget {
  final Widget Function(T) builder;
  final Widget Function(T)? tabBuilder;
  final ObjectDBFilter<T> filter;
  TabsArea({
    Key? key,
    required this.filter,
    required this.builder,
    this.tabBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
          length: filter.list.length,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TabBar(
                    labelPadding: (T == ImageFractal)
                        ? const EdgeInsets.only(right: 1)
                        : null,
                    isScrollable: true,
                    unselectedLabelColor: Colors.grey[400],
                    indicatorWeight: 1,
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: [
                      ...filter.list.map(
                        (f) => tabBuilder != null
                            ? tabBuilder!(f)
                            : Tab(
                                text: tabBuilder == null
                                    ? f.title
                                        .ifEmpty(() => f.name.capitalizeFirst)
                                    : null,
                              ),
                      ),
                    ],
                  ).expand(),
                  buildPlus(),
                ],
              ),
              TabBarView(
                physics: const BouncingScrollPhysics(),
                children: [
                  //widget.builder(XI.take<T>()),
                  ...filter.list.map(
                    (f) => builder(f),
                  ),
                ],
              ).expand(),
            ],
          ),
        ));
  }

  final ctrl = TextEditingController();

  Widget buildPlus() => (T == ImageFractal)
      ? IconButton(
          onPressed: () async {
            FilePickerCross myFile = await FilePickerCross.importFromStorage(
              type: FileTypeCross.any,
            );

            final image = ImageFractal();
            image.set({
              'parent_id': filter.query['parent_id'],
            });
            await image.save();

            await image.fromPicker(myFile);
            //filter.add(image);
          },
          icon: Icon(Icons.add),
        )
      : Container(
          width: 128,
          child: TextFormField(
            controller: ctrl,
            onFieldSubmitted: (value) async {
              final f = XI.take<T>();
              f.set({
                'parent_id': filter.query['parent_id'],
                'title': value,
                'name': value.toLowerCase(),
              });
              await f.save();
              ctrl.clear();
              filter.add(f);
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.add),
              labelText: 'Add new',
              hintText: T.toString(),
            ),
          ),
        );
}
