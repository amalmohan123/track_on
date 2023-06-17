import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageProvider with ChangeNotifier {
  bool isGridveiw = true;
  void viewtype() {
    isGridveiw = !isGridveiw;
    notifyListeners();
    
    
  }
}
