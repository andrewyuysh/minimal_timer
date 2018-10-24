import 'dart:async';
import 'package:flutter/material.dart';

const Color color_sky = Color(0xFFAF4130);
const Color color_mnt = Color(0xFF201E29);
const Color color_sun = Color(0xFFE3E1D4);

enum timerState {
  ready,
  running,
  paused,
}

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

class MTimer extends StatefulWidget {
  @override
  _MTimerState createState() => _MTimerState();
}

class _MTimerState extends State<MTimer> {
  Timer timer;
  Duration _currentTime = Duration(seconds: 0);
  Duration startTime = Duration(seconds: 0);
  timerState state = timerState.ready;
  final Stopwatch stopwatch = new Stopwatch();
  double dragCounter = 0.0;

  _MTimerState({
    this.startTime = const Duration(seconds: 80),
  });

  get currentTime {
    return _currentTime;
  }

  _tick() {
    _currentTime = startTime - stopwatch.elapsed;
    setState(() {});
  }

  reset() {
    state = timerState.ready;
    stopwatch.reset();
    stopwatch.stop();
    _currentTime = startTime;
    if (timer != null) timer.cancel();
    setState(() {});
  }

  resume() {
    state = timerState.running;
    stopwatch.start();

    timer = new Timer.periodic(new Duration(milliseconds: 100), (timer) {
      //60 frames / 1000 millisecs
      _tick();
    });
  }

  //use actual currentTime (millis instead of seconds)
  //drag also modifies millis
  //when drag is let go, then snap to the nearest second
  dragTime(details) {
    startTime -= Duration(milliseconds: (details.primaryDelta * 30).toInt());
    reset();
  }

  dragEnd() {
    startTime = Duration(seconds: startTime.inSeconds);
    reset();
  }

  tap() {
    if (state == timerState.running)
      reset();
    else if (state == timerState.ready) resume();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      // alignment: Alignment(0.0, currentTime.inSeconds.toDouble() / -80.0),
      children: <Widget>[
        new Container(
          color: color_mnt,
          constraints: BoxConstraints.expand(),
          child: new ClipPath(
            clipper: MountainClipper(),
            child: new Stack(
              // alignment: Alignment(0.0, 0.0),
              alignment: Alignment(
                  0.0,
                  ((currentTime.inMilliseconds.toDouble() / 1000 - 67.0) /
                      -80.0)),
              children: <Widget>[
                new Container(color: color_sky),
                new Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    new Container(
                      width: 80.0,
                      height: 80.0,
                      // color: Colors.black,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: color_sun,
                      ),
                    ),
                    new Text(
                      '${sec2str(startTime.inSeconds - stopwatch.elapsed.inSeconds)}',
                      style: TextStyle(
                        fontSize: 36.0,
                        color: color_sky,
                      ),
                      softWrap: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        new GestureDetector(
          onTap: tap,
          onVerticalDragUpdate: (details) => dragTime(details),
          onVerticalDragEnd: (details) => dragEnd(),
        ),
      ],
    );
  }
}

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
