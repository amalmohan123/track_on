import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';


import '../Model/fav_model.dart';

class PlaylistDb extends ChangeNotifier {
  List<FavModel> playListNotifier = [];
  final playlistDb = Hive.box<FavModel>('playlistDb');

  Future<void> addPlaylist(FavModel value) async {
    final playlistDb = Hive.box<FavModel>('playlistDb');
    await playlistDb.add(value);
    playListNotifier.add(value);
  }

  Future<void> getAllPlaylist() async {
    final playlistDb = Hive.box<FavModel>('playlistDb');
    playListNotifier.clear();
    playListNotifier.addAll(playlistDb.values);
    notifyListeners();
  }

  Future<void> deletePlaylist(int inbox) async {
    final playlistDb = Hive.box<FavModel>('playlistDb');
    await playlistDb.deleteAt(inbox);
    getAllPlaylist();
  }

  Future<void> editList(int index, FavModel value) async {
    final playlistDb = Hive.box<FavModel>('playlistDb');
    await playlistDb.putAt(index, value);
    getAllPlaylist();
    notifyListeners();
  }
}
