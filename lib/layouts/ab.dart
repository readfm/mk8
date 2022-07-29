import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fractal_gold/areas/profile.dart';
import 'package:fractal_gold/auth/area.dart';
import 'package:fractal_gold/controllers/scaffold.dart';
import 'package:fractal_gold/dialog/node.dart';
import 'package:fractal_gold/extensions/icon.dart';
import 'package:fractal_gold/models/app.dart';
import 'package:fractal_gold/widgets/listen.dart';
import 'package:fractal_gold/widgets/sliding.dart';
import 'package:fractal_word/word.dart';
import 'package:fractals/models/account.dart';
import 'package:fractals/models/node.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class AbLayout extends StatefulWidget {
  AppFractal fractal;
  Widget Function()? authArea;
  Function(RawKeyEvent event, BuildContext context)? onKey;
  AbLayout(this.fractal, {Key? key, this.authArea, this.onKey})
      : super(key: key);

  @override
  State<AbLayout> createState() => _AbLayoutState();
}

class _AbLayoutState extends State<AbLayout>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late ThemeData theme;

  late final AnimationController _animCtrl;

  @override
  void initState() {
    AppFractal.active = widget.fractal;
    theme = widget.fractal.skin.light;
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ScaffoldCtrl());
    return FChangeNotifierProvider.value(
      value: widget.fractal,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: widget.fractal.skin.light,
        home: false //widget.fractal.onlyAuthorized == true
            ? Scaffold(
                appBar: AppBar(
                  title: Text(
                    widget.fractal.skin.title,
                    style: GoogleFonts.gugi(
                      fontSize: 26,
                    ),
                  ),
                ),
                body: AuthArea(),
              )
            : Builder(
                builder: scaffold,
              ),
      ),
    );
  }

  bool terminalOn = false;

  Widget scaffold(BuildContext context) {
    final height = Get.height;
    return widget.fractal.mainGate != null
        ? Listen(
            Acc.status,
            (ctx, child) => (Acc.status.value != 1)
                ? Scaffold(
                    body: widget.fractal.mainGate!(),
                  ).expand()
                : gapp,
          )
        : Scaffold(
            primary: true,
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            //drawerScrimColor: Colors.red,
            extendBodyBehindAppBar: true,
            body: gapp,
            //appBar: bar(context),
            drawer: drawer(context),
            endDrawer: endDrawer(context),
          );
  }

  SlidingBar bar(BuildContext context) => SlidingBar(
        controller: _animCtrl,
        visible: !widget.fractal.hideAppBar,
        child: AppBar(
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          //shadowColor: Colors.transparent,// Color.fromARGB(128, 128, 128, 128),
          leading: ElevatedButton(
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: widget.fractal.skin.icon,
            ),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              padding: EdgeInsets.all(0),
              shape: CircleBorder(),
            ),
          ).p4(),
          backgroundColor: Color(0x4B000000),
          title: (MediaQuery.of(context).size.width > 500)
              ? InkWell(
                  onTap: () {
                    Get.toNamed("/");
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Row(children: [
                      Text(
                        widget.fractal.skin.title,
                        style: GoogleFonts.gugi(
                          fontSize: 26,
                        ),
                      ),
                    ]),
                  ),
                )
              : null,
          //actions: layActions(context),
        ),
      );

  Widget get gapp => Builder(
        builder: (ctx) => RawKeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          onKey: (event) {
            if (widget.onKey != null) widget.onKey!(event, ctx);
          },
          child: GetMaterialApp(
            theme: theme,
            debugShowCheckedModeBanner: false,
            title: widget.fractal.skin.title,
            initialRoute: "/",
            getPages: <GetPage>[
              ...widget.fractal.screens.map(
                (screen) => GetPage(
                  name: '/' + screen.name.value,
                  page: () => FChangeNotifierProvider.value(
                    value: screen,
                    child: screen.builder(),
                  ),
                ),
              ),
              GetPage(
                name: '/',
                page: () => FChangeNotifierProvider.value(
                  value: widget.fractal.home,
                  child: widget.fractal.home.builder(),
                ),
              ),
            ],
          ),
        ),
      );

  final phone = '';
  layActions(BuildContext context) {
    return <Widget>[
      ...widget.fractal.screens.map(
        (screen) => IconButton(
          icon: Icon(screen.icon),
          tooltip: screen.title.value,
          onPressed: () {
            Get.toNamed('/' + screen.name.value);
          },
        ),
      ),
      ...widget.fractal.actions.map((w) => w(context)),
      const SizedBox(width: 24),
      /*
      InkWell(
        onTap: () {
          _scaffoldKey.currentState!.openEndDrawer();
          //Scaffold.of(context).openEndDrawer();
        },
        child: IgnorePointer(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Listen(
              Acc.status,
              (ctx, child) => (Acc.status.value == 1)
                  ? Listen(
                      Acc.me!,
                      (ctx, child) => Acc.me!.profile == null
                          ? Icon(
                              Icons.person_outline,
                            )
                          : Row(
                              children: <Widget>[
                                if (MediaQuery.of(context).size.width > 500)
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(18, 0, 8, 0),
                                    child: Text(
                                      Acc.me!.profile?.fullName ?? '',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                Acc.me!.profile == null
                                    ? Icon(Icons.person)
                                    : Avatar(Acc.me!.profile!, size: 48)
                              ],
                            ),
                    )
                  : Icon(Icons.lock),
            ),
          ),
        ),
      ),
      InkWell(
        onTap: () {},
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 8, 0),
              child: Text(
                'Jeremy Clarkson',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      */
    ];
  }

  endDrawer(context) {
    final ctrl = Get.put(ScaffoldCtrl());
    return Drawer(
      child: SafeArea(
        child: Listen(
          Acc.status,
          (ctx, child) => (Acc.status.value == 1)
              ? Column(
                  children: [
                    AccountHeaderArea(),
                  ],
                )
              : Container(
                  height: 600,
                  child:
                      widget.authArea != null ? widget.authArea!() : AuthArea(),
                ),
        ),
      ),
    );
  }

  //final nodes = ObjectDBFilter<NodeModel>({});

  drawer(context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(children: [
              ...Word.map.values.map(
                (w) => ListTile(
                  leading: Icon(w.icon),
                  title: Text(w.name),
                ),
              ),
            ]),
          ),
          Container(
            height: 32,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add new organisation',
                  onPressed: () {
                    showDialog(
                      context: Get.context!,
                      builder: (BuildContext context) => NodeDialog(
                        NodeModel(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
