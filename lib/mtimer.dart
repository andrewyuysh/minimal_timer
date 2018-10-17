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

  _tick() {
    _currentTime = startTime - Duration(seconds: stopwatch.elapsed.inSeconds);
    if (null != timerUpdate) {
      timerUpdate();
    }
  }

  reset() {
    state = timerState.ready;
    stopwatch.reset();
    stopwatch.stop();
    _currentTime = startTime;
    if (null != timerUpdate) {
      timerUpdate();
    }
    if (timer != null) timer.cancel();
  }

  resume() {
    state = timerState.running;
    stopwatch.start();

    timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      _tick();
    });
  }

  fullScreenButton() {
    if (state == timerState.running)
      reset();
    else if (state == timerState.ready) resume();
  }
}

enum timerState {
  ready,
  running,
  paused,
}
