import 'dart:async';

class MTimer {
  Timer timer;
  Duration _currentTime = Duration(seconds: 0);
  // int _currentTime = 0;
  Duration startTime = Duration(seconds: 0);
  Function timerUpdate;
  timerState state = timerState.ready;
  final Stopwatch stopwatch = new Stopwatch();

  MTimer({
    this.startTime,
    this.timerUpdate,
  });

  get currentTime {
    return _currentTime;
  }

  // resume() {
  //   if (state == timerState.running) return;
  //   state = timerState.running;
  //   stopwatch.start();
  //   _tick();
  // }

  _tick() {
    _currentTime = startTime - stopwatch.elapsed;
    if (null != timerUpdate) {
      timerUpdate();
    }
  }

  restart() {
    state = timerState.running;

    stopwatch.reset();
    _tick();
    stopwatch.start();

    if (timer != null) timer.cancel();
    timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      _tick();
    });
  }
}

enum timerState {
  ready,
  running,
  paused,
}
