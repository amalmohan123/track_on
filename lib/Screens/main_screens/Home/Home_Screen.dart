import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:track_on/Screens/main_screens/Home/viewtype/grid_view.dart';
import '../../../Controller/all_song_controller.dart';
import '../../../Database/fav_database.dart';
import '../../../Provider/Song_model_provider.dart';
import '../../../Provider/home_page_provider/Home_provider.dart';
import '../../mini_screens/PlayScreen.dart';
import 'Search_Screen.dart';
import 'menu_Button.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final OnAudioQuery _audioQuery = OnAudioQuery();

  final AudioPlayer _audioPlayer = AudioPlayer();

  List<SongModel> allSongs = [];

  void playSong(String? uri) {
    try {
      _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(uri!),
        ),
      );
      _audioPlayer.play();
    } on Exception {
      log('Error parsing Song');
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      GetAllSongController.audioPlayer.currentIndexStream.listen((index) {});
    });

    return WillPopScope(
      onWillPop: () {
        _onButtonPressed(context);
        return Future.value(false);
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 36, 16, 80),
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Consumer<HomePageProvider>(
                builder: (context, value, child) => IconButton(
                  onPressed: () {
                    value.viewtype();
                  },
                  icon: Icon(value.isGridveiw
                      ? Icons.grid_view_rounded
                      : Icons.list_rounded),
                  iconSize: 28,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  width: 90,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const SearchScreen();
                          },
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(left: 0.1),
              child: SizedBox(
                child: Text(
                  'TrackOn',
                  style: GoogleFonts.aclonica(fontSize: 20),
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        // color: Colors.white,
                        height: 550,
                        width: double.infinity,
                        child: FutureBuilder<List<SongModel>>(
                          future: _audioQuery.querySongs(
                              sortType: null,
                              orderType: OrderType.ASC_OR_SMALLER,
                              uriType: UriType.EXTERNAL),
                          builder: ((context, items) {
                            if (items.data == null) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (items.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No Songs found',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }
                            startSong = items.data!;
                            if (Provider.of<FavoriteDb>(context)
                                .isInitialized) {
                              Provider.of<FavoriteDb>(context)
                                  .initialize(items.data!);
                            }
                            GetAllSongController.songscopy = items.data!;
                            // for playlist

                            return Provider.of<HomePageProvider>(context)
                                    .isGridveiw
                                ? listViewType(items)
                                : GridViewType(
                                    allSongs: allSongs,
                                    items: items,
                                  );
                          }),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView listViewType(AsyncSnapshot<List<SongModel>> items) {
    return ListView.builder(
      itemBuilder: (context, index) {
        allSongs.addAll(items.data!);
        return Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                border: Border.all(
                    color: const Color.fromARGB(255, 183, 183, 247),
                    width: 1.4),
                color: const Color.fromARGB(255, 28, 13, 61),
              ),
              child: ListTile(
                iconColor: Colors.white,
                selectedColor: Colors.purpleAccent,
                leading: QueryArtworkWidget(
                  id: items.data![index].id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 30,
                    backgroundImage: AssetImage(
                        'assets/Image/WhatsApp_Image_2023-03-17_at_10.24.28-removebg-preview.png'),
                  ),
                ),
                title: Text(
                  items.data![index].displayNameWOExt,
                  style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'poppins',
                      color: Colors.white),
                ),
                subtitle: Text(
                  items.data![index].artist.toString() == "<unknown>"
                      ? "Unknown Artist"
                      : items.data![index].artist.toString(),
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'poppins',
                    fontSize: 12,
                    color: Color.fromARGB(255, 150, 160, 165),
                  ),
                ),
                trailing: FavOrPlayMenuButton(
                    songFavorite: startSong[index], findex: index),
                onTap: () {
                  GetAllSongController.audioPlayer.setAudioSource(
                      GetAllSongController.createSongList(items.data!),
                      initialIndex: index);

                  context
                      .read<SongModelProvider>()
                      .setId(items.data![index].id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PlayScreen(
                          songModelList: items.data!,
                          count: items.data!.length,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      itemCount: items.data!.length,
    );
  }

  Future<bool> _onButtonPressed(BuildContext context) async {
    bool? exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(126, 59, 214, 0.937),
          title: const Text(
            'EXIT APP',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Do you want to close this app?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(
                    color: Color.fromARGB(255, 241, 240, 244), fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text(
                'YES',
                style: TextStyle(
                    color: Color.fromARGB(255, 243, 242, 244), fontSize: 15),
              ),
            )
          ],
        );
      },
    );
    return exitApp ?? false;
  }
}

List<SongModel> startSong = [];
