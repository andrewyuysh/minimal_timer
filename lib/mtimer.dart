import 'dart:async';

class MTimer {
  Duration _currentTime = Duration(seconds: 0);
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

  resume() {
    if (state == timerState.running) return;
    state = timerState.running;
    stopwatch.start();
    _tick();
  }

  _tick() {
    new Timer(const Duration(seconds: 1), _tick);
    _currentTime = startTime - stopwatch.elapsed;
    if (null != timerUpdate) {
      timerUpdate();
    }
  }

  restart() {
    state = timerState.running;
    startTime = Duration(seconds: 60);
    stopwatch.reset();
    stopwatch.start();
    _tick();
  }
}

enum timerState {
  ready,
  running,
  paused,
}
