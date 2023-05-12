import 'package:flutter/material.dart';

class MySliderModel extends ChangeNotifier {
  double _value = 0.0;
  int get selectedValue => _value.round();

  void updateValue(double value) {
    _value = value;
    print(_value);
    notifyListeners();
  }

  double get value => _value;
}
