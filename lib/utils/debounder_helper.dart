import 'dart:async';
import 'dart:ui';

import 'package:get/get.dart';

class Debouncer extends GetxService {
  Duration? delay;
  Timer? _timer;
  VoidCallback? _callback;


  Debouncer({this.delay = const Duration(milliseconds: 500)});

  void debounce(VoidCallback callback) {
    _callback = callback;

    cancel();
    _timer =  Timer(delay!, flush);
  }

  void cancel() {
    if (_timer != null) {
      _timer?.cancel();
    }
  }

  void flush() {
    _callback!();
    cancel();
  }
}