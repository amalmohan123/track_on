import 'package:flutter/cupertino.dart';

class BottomNavProvider with ChangeNotifier {
  int currentSelectedIndex = 0;
  void bottomSwitching(index) {
    currentSelectedIndex = index;
    notifyListeners();
  }
}
