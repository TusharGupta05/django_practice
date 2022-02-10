import 'package:flutter/foundation.dart';

class SelectorProvider<T> extends ChangeNotifier {
  T val;
  SelectorProvider(this.val);
  void change(T newVal) {
    val = newVal;
    notifyListeners();
  }
}
