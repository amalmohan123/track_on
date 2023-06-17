import 'package:flutter/cupertino.dart';

import '../../Controller/all_song_controller.dart';

class NowProvider extends ChangeNotifier {
  bool isShuffling = false;   
  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    GetAllSongController.audioPlayer.seek(duration);
  }
}
