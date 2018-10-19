//function calls w/ or w/o ()?
//setState() calls build (refreshes screen)
//timerUpdate() is used to call setState() indirectly from mtimer.dart
//if timer is running -> reset, overlapping _tick() calls are made

////_tick() call -> rendering display takes ~1.02 seconds, not exactly 1.00
////FIXED USING Timer.periodic() -> _tick() instead of each _tick() running its own timer
//var timer = new Timer();
//Timer timer; what's the diff?
//mgestures?

import 'package:flutter/material.dart';
import 'package:minimal_timer/mtimer.dart';

void main() => runApp(new MyApp());

String sec2str(int sec) {
  bool neg = sec < 0;
  if (neg) sec *= -1;
  bool lessthanmin = sec < 60;
  String out = "";
  if (neg) out += '-';
  if (!lessthanmin) {
    return out +
        (sec ~/ 60).toString() +
        ":" +
        (sec %= 60).toString().padLeft(2, '0');
  }
  return out + sec.toString();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MTimer timer;
  int startTime = 0;
  double dragCounter = 0.0;

  //constructor allows arguments to the MTimer constructor
  _MyHomePageState() {
    timer = new MTimer(
      startTime: Duration(seconds: startTime),
      timerUpdate: _timerUpdate,
    );
  }

  //function for drag gestures
  drag(DragUpdateDetails details) {
    timer.dragTime(details);
  }

  //function for tap gestures
  tap() {
    timer.tap();
    setState(() {});
  }

  //function from mtimer.dart that allows the main to refresh/setState
  _timerUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(
            constraints: BoxConstraints.expand(),
            // height: MediaQuery.of(context).size.height,
            // width: MediaQuery.of(context).size.width,
            color: Color(0xff212028), //MOUNTAIN COLOR
            child: new ClipPath(
              clipper: MountainClipper(),
              child: Container(
                color: Color(0xffad4232), //SKY COLOR
                child: new Stack(
                  children: <Widget>[
                    Center(
                      child: new Container(
                        height:
                            MediaQuery.of(context).size.width * 312.0 / 2048.0,
                        width:
                            MediaQuery.of(context).size.width * 312.0 / 2048.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffe0e3d2), //SUN COLOR
                        ),
                        child: new Center(
                          child: new Text(
                            '${sec2str(timer.currentTime.inSeconds)}',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Color(0xffad4232),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          new GestureDetector(
            onTap: tap,
            onVerticalDragUpdate: (details) => drag(details),
          ),
        ],
      ),
    );
  }
}

// new Stack(
//   children: <Widget>[
//     new Center(
//       child: new Container(
//         height: 200.0,
//         width: 200.0,
//         decoration: new BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.red,
//         ),
//       ),
//     ),
//     new ClipPath(
//       child: new Container(
//         alignment: Alignment.bottomCenter,
//         height: 200.0,
//         width: 200.0,
//         decoration: new BoxDecoration(
//           shape: BoxShape.rectangle,
//           color: Colors.blue,
//         ),
//       ),
//       clipper: MountainClipper(),
//     ),
//     new Center(
//       child: new Text(
//         '${sec2str(timer.currentTime.inSeconds)}',
//         style: TextStyle(fontSize: 100.0),
//       ),
//     ),
//     new GestureDetector(
//       onTap: tap,
//       onVerticalDragUpdate: (details) => drag(details),
//     ),

// new Opacity(
//   opacity: 0.4,
//   child: new RawMaterialButton(
//     onPressed: fullScreenButton,
//     fillColor: Colors.red,
//     constraints: BoxConstraints(
//         minHeight: double.infinity, minWidth: double.infinity),
//   ),
// ),

class MountainClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    double heightratio = 848.0 / 1300.0;
    // path.lineTo(size.width / 2.0,
    //     size.height - (size.width / 2.0 * 1.28)); // 45deg right triangle
    path.lineTo(size.width / 2.0 * heightratio,
        size.height - (heightratio * size.width / 2.0 * 1.27));
    path.lineTo(size.width - size.width / 2.0 * heightratio,
        size.height - (heightratio * size.width / 2.0 * 1.27));

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
