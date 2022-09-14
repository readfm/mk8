import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractals/io.dart';
import 'package:quill_format/quill_format.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zefyrka/zefyrka.dart';

class WysiwygInput extends StatefulWidget {
  String name;
  WysiwygInput({
    Key? key,
    required this.name,
  }) : super(key: key);

  static NotusDocument createEmptyDoc() {
    final json = r'[{"insert":"\n"}]';
    return NotusDocument.fromJson(jsonDecode(json));
  }

  @override
  State<WysiwygInput> createState() => _WysiwygInputState();
}

class _WysiwygInputState extends State<WysiwygInput>
    with AutomaticKeepAliveClientMixin<WysiwygInput> {
  late TextEditingController _ctrl;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _ctrl = TextEditingController();
    const json =
        r'[{"insert":"Building a rich text editor"},{"insert":"\n","attributes":{"heading":1}},{"insert":{"_type":"hr","_inline":false}},{"insert":"\n"},{"insert":"https://github.com/memspace/zefyr","attributes":{"a":"https://github.com/memspace/zefyr"}},{"insert":"\nZefyr is the first rich text editor created for Flutter framework.\nHere we go again. This is a very long paragraph of text to test keyboard event handling."},{"insert":"\n","attributes":{"block":"quote"}},{"insert":"Hello world!"},{"insert":"\n","attributes":{"block":"quote"}},{"insert":"So many features"},{"insert":"\n","attributes":{"heading":2}},{"insert":"Example of numbered list:\nMarkdown semantics"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"Modern and light look"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"One more thing"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"And this one is just superb and amazing and awesome"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"I can go on"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"With so many posibilitities around"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"Here we go again. This is a very long paragraph of text to test keyboard event handling."},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"And a couple more"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"Finally the tenth item"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"Whoohooo"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"This is bold text. And the code:\nvoid main() {"},{"insert":"\n","attributes":{"block":"code"}},{"insert":"  print(\"Hello world!\"); // with a very long comment to see soft wrapping"},{"insert":"\n","attributes":{"block":"code"}},{"insert":"}"},{"insert":"\n","attributes":{"block":"code"}},{"insert":"Above we have a block of code.\n"}]';
    //_controller.addListener(_print);
    initEmpty();
    super.initState();
    load();
  }

  late final file = File(FIO.documentsPath + widget.name + '.json');
  load() async {
    final cont = await file.readAsString();
    if (cont.isNotBlank) {
      //final document = NotusDocument.fromJson(jsonDecode(cont));

      final delta = Delta.fromJson(jsonDecode(cont));

      _controller.document.compose(delta, ChangeSource.remote);

      return;
    }
  }

  initEmpty() {
    setState(() {
      _controller = ZefyrController(
        WysiwygInput.createEmptyDoc(),
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  save() async {
    final doc = _controller.document;

    if (doc != null) {
      file.writeAsString(
        jsonEncode(
          doc.toJson(),
        ),
      );

      //_controller.document.compose(doc.toDelta(), ChangeSource.local);
    }

    //initEmpty();
  }

  late ZefyrController _controller;
  final FocusNode _focusNode = FocusNode();

  /*
  load() {
    var doc = null;

    final document = doc != null
        ? NotusDocument.fromJson(jsonDecode(doc))
        : NotusDocument.fromDelta(Delta()..insert("\n"));
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      bottomNavigationBar: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(12, 2, 12, 2),
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          ElevatedButton(
            child: const Icon(Icons.save),
            onPressed: () {
              print(_controller.document.toJson());
              save();
            },
          ),
          ZefyrToolbar.basic(
            controller: _controller,
          ),
        ]),
      ),
      body: Container(
        color: Colors.grey.shade200,
        padding: EdgeInsets.fromLTRB(12, 2, 12, 2),
        child: ZefyrField(
          autofocus: false,
          controller: _controller,
          focusNode: _focusNode,
          // readOnly: true,
          minHeight: 300, expands: true,
          padding: EdgeInsets.only(top: 4, left: 0, right: 0),
          onLaunchUrl: _launchUrl,
        ),
      ),
    );
    /*
        if (acc.fractal != null)
          ElevatedButton(
            child: Text('send'),
            onPressed: () {
              final item = Message();
              item.owner = acc.fractal!.profile!;
              item.text = _ctrl.text;
              widget.post(item);
              _ctrl.text = '';
            },
          ).box.alignTopRight.make()
          */
  }

  void _print() {
    // print(jsonEncode(_controller.document));
  }

  void _launchUrl(String? url) async {
    if (url == null) return;
    final result = await canLaunch(url);
    if (result) {
      await launch(url);
    }
  }
}
