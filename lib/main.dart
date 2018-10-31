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

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // Animation<double> animation;
  // AnimationController controller;

  // MTimer timer;
  // int startTime = 0;
  // double dragCounter = 0.0;

  // initState() {
  //   super.initState();
  //   controller = AnimationController(
  //       duration: const Duration(milliseconds: 10000), vsync: this);
  //   animation = Tween(begin: 30.0, end: 300.0).animate(controller)
  //     ..addListener(() {
  //       setState(() {
  //         // the state that has changed here is the animation object’s value
  //       });
  //     });
  //   // controller.forward();
  //   controller.repeat();
  // }

  // dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  //constructor allows arguments to the MTimer constructor
  _MyHomePageState();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // backgroundColor: Colors.white,
      body: MTimer(startTime: Duration(seconds: 80)),
    );
  }
}
