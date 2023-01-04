import 'dart:async';

class Debouncer {
  Duration delay;
  var callback;
  List? args;
  bool? atBegin;

  Debouncer(this.delay, this.callback, this.args, [this.atBegin = false]);

  var timeoutId;

  void debounce() {
    void exec() {
      callback(args);
    }

    void clear() {
      timeoutId = null;
    }

    //cancel the previous timer if debounce is still being called before the delay period is over
    if (timeoutId != null) {
      timeoutId.cancel();
    }
    //if atBegin is true, 'exec' has to executed the first time debounce gets called
    if (atBegin == true && timeoutId == null) {
      exec();
    }
    //schedule a new call after delay time
    timeoutId = Timer(delay, atBegin == true ? clear : exec);
  }
}
