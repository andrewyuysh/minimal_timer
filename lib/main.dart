//function calls w/ or w/o ()?
//setState() calls build (refreshes screen)
//timerUpdate() is used to call setState() indirectly from mtimer.dart
//if timer is running -> reset, overlapping _tick() calls are made
////_tick() call -> rendering display takes ~1.02 seconds, not exactly 1.00
////FIXED USING Timer.periodic() -> _tick() instead of each _tick() running its own timer
//var timer = new Timer();
//Timer timer; what's the diff?

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

  //constructor allows arguments to the MTimer constructor
  _MyHomePageState() {
    timer = new MTimer(
      startTime: Duration(seconds: -100),
      timerUpdate: _timerUpdate,
    );
  }

  //function for button
  restartTimer() {
    timer.restart();
    setState(() {});
  }

  //function from mtimer.dart that allows the main to refresh/setState
  _timerUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text('${sec2str(timer.currentTime.inSeconds)}',
                style: TextStyle(fontSize: 100.0)),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: restartTimer,
        tooltip: 'Increment',
        child: new Icon(Icons.delete),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
