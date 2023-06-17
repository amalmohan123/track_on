import 'package:flutter/cupertino.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../Screens/main_screens/Home/Search_Screen.dart';

class SearchProvider extends ChangeNotifier {
  List<SongModel> foundSongs = [];

  void updateList(String enteredText) {
    List<SongModel> results = [];
    if (enteredText.isEmpty) {
      results = allsongs;
    } else {
      results = allsongs
          .where((element) => element.displayNameWOExt
              .toLowerCase()
              .contains(enteredText.toLowerCase()))
          .toList();
    }
    foundSongs = results;
    notifyListeners();
  }
}
