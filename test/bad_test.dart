import 'dart:async';

main() {
  Timer timer = new Timer.periodic(new Duration(seconds: 5), (timer) {
    print('Something');
  });

// Stop the periodic timer using another timer which runs only once after specified duration
  new Timer(new Duration(minutes: 1), () {
    print('hey');
  });
}
