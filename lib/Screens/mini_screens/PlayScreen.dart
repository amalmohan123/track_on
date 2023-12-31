import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';
import '../../Controller/all_song_controller.dart';
import '../../Model/fav_model.dart';
import '../../Provider/Now_playing_provider/now_playing_provider.dart';
import '../../database/playlist_db.dart';
import '../main_screens/favorites/favorite_notify.dart';
import '../main_screens/playlist/playlist_screen.dart';
import 'art_work_widget.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key, required this.songModelList, this.count = 0});
  final List<SongModel> songModelList;
  final dynamic count;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _PlayScreenState extends State<PlayScreen> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _firstsong = false;
  List<AudioSource> songList = [];
  bool _lastSong = false;
  int currentIndex = 0;
  int large = 0;

  @override
  void initState() {
    GetAllSongController.audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        GetAllSongController.currentIndexes = index;
        if (mounted) {
          setState(() {
            large = widget.count - 1; //store the last song's index number

            currentIndex = index;
            index == 0 ? _firstsong = true : _firstsong = false;
            index == large ? _lastSong = true : _lastSong = false;
          });
        }

        log('index of last song ${widget.count}');
      }
    });
    super.initState();
    playSong();
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return '--:--';
    } else {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }
  }

  void playSong() {
    GetAllSongController.audioPlayer.play();
    GetAllSongController.audioPlayer.durationStream.listen((d) {
      if (mounted) {
        setState(() {
          _duration = d!;
        });
      }
    });
    GetAllSongController.audioPlayer.positionStream.listen((p) {
      if (mounted) {
        setState(() {
          _position = p;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final playListPro = Provider.of<PlaylistDb>(context);
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 36, 16, 80),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 8, left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            const Text(
                              'NOW PLAYING',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  fontFamily: 'poppins'),
                            ),
                            const SizedBox(
                              width: 45,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Stack(
                        children: [
                          const Positioned(
                            height: 300,
                            width: 300,
                            child: ArtWorkWidget(),
                          ),
                          Opacity(
                            opacity: .1,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45),
                                  gradient: const LinearGradient(colors: [
                                    Color.fromARGB(255, 209, 14, 206),
                                    Color.fromARGB(255, 170, 121, 137),
                                    Color.fromARGB(255, 202, 191, 195)
                                  ])),
                              height: 300,
                              width: 300,
                            ),
                          )
                        ],
                      ),
                      //
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 50, left: 50),
                        child: TextScroll(
                          widget.songModelList[currentIndex].displayNameWOExt,
                          style: const TextStyle(
                            fontFamily: 'poppins',
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          mode: TextScrollMode.endless,
                          pauseBetween: const Duration(seconds: 3),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FavButMusicPlayr(
                                songFavoriteMusicPlaying:
                                    widget.songModelList[currentIndex]),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 250,
                              child: Center(
                                child: TextScroll(
                                  widget.songModelList[currentIndex].artist
                                              .toString() ==
                                          "<unknown>"
                                      ? "Unknown Artist"
                                      : widget
                                          .songModelList[currentIndex].artist
                                          .toString(),
                                  style: const TextStyle(
                                    fontFamily: 'poppins',
                                    color: Colors.white54,
                                    fontSize: 15,
                                  ),
                                  mode: TextScrollMode.endless,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                                onPressed: () {
                                  showPlaylistdialog(context, playListPro);
                                },
                                icon: const Icon(
                                  Icons.playlist_add,
                                  color: Colors.white,
                                  size: 30,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: SizedBox(
                          height: 30,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_formatDuration(_position),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'poppins')),
                                SizedBox(
                                  width: 280,
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                        thumbColor: Colors.deepPurple,
                                        thumbShape: const RoundSliderThumbShape(
                                            enabledThumbRadius: 8)),
                                    child: Consumer<NowProvider>(
                                      builder: (context, values, child) =>
                                          Slider(
                                        activeColor: Colors.purpleAccent,
                                        inactiveColor: Colors.white38,
                                        min: const Duration(microseconds: 0)
                                            .inSeconds
                                            .toDouble(),
                                        value: _position.inSeconds.toDouble(),
                                        max: _duration.inSeconds.toDouble(),
                                        onChanged: (value) {
                                          if (mounted) {
                                            values
                                                .changeToSeconds(value.toInt());
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Text(_formatDuration(_duration),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'poppins')),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Consumer<NowProvider>(
                            builder: (context, value, child) => IconButton(
                              onPressed: () {
                                value.isShuffling == false
                                    ? GetAllSongController.audioPlayer
                                        .setShuffleModeEnabled(true)
                                    : GetAllSongController.audioPlayer
                                        .setShuffleModeEnabled(false);
                              },
                              icon: StreamBuilder<bool>(
                                stream: GetAllSongController
                                    .audioPlayer.shuffleModeEnabledStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  value.isShuffling = snapshot.data;
                                  if (value.isShuffling) {
                                    return const Icon(
                                      Icons.shuffle_rounded,
                                      color: Colors.purpleAccent,
                                    );
                                  } else {
                                    return const Icon(
                                      Icons.shuffle_rounded,
                                      color: Colors.white,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          _firstsong
                              ? const IconButton(
                                  iconSize: 40,
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.skip_previous_outlined,
                                    color: Color.fromARGB(210, 102, 94, 121),
                                  ))
                              : IconButton(
                                  iconSize: 40,
                                  onPressed: () {
                                    if (GetAllSongController
                                        .audioPlayer.hasPrevious) {
                                      GetAllSongController.audioPlayer
                                          .seekToPrevious();
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.skip_previous_outlined,
                                    color: Colors.white,
                                  )),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 62, 29, 120),
                                splashFactory: NoSplash.splashFactory,
                                shadowColor: Colors.transparent,
                                shape: const CircleBorder()),
                            onPressed: () async {
                              if (GetAllSongController.audioPlayer.playing) {
                                await GetAllSongController.audioPlayer.pause();
                              } else {
                                await GetAllSongController.audioPlayer.play();
                              }
                            },
                            child: StreamBuilder<bool>(
                              stream: GetAllSongController
                                  .audioPlayer.playingStream,
                              builder: (context, snapshot) {
                                bool? playingStage = snapshot.data;
                                if (playingStage != null && playingStage) {
                                  return const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Icon(
                                      Icons.pause_outlined,
                                      color: Colors.white,
                                      size: 65,
                                    ),
                                  );
                                } else {
                                  return const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Icon(
                                      Icons.play_arrow_outlined,
                                      color: Colors.white,
                                      size: 65,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          _lastSong
                              ? const IconButton(
                                  iconSize: 40,
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.skip_next_outlined,
                                    color: Color.fromARGB(210, 102, 94, 121),
                                  ))
                              : IconButton(
                                  iconSize: 40,
                                  onPressed: () {
                                    if (GetAllSongController
                                        .audioPlayer.hasNext) {
                                      GetAllSongController.audioPlayer
                                          .seekToNext();
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.skip_next_outlined,
                                    color: Colors.white,
                                  )),
                          IconButton(
                            onPressed: () {
                              GetAllSongController.audioPlayer.loopMode ==
                                      LoopMode.one
                                  ? GetAllSongController.audioPlayer
                                      .setLoopMode(LoopMode.all)
                                  : GetAllSongController.audioPlayer
                                      .setLoopMode(LoopMode.one);
                            },
                            icon: StreamBuilder<LoopMode>(
                              stream: GetAllSongController
                                  .audioPlayer.loopModeStream,
                              builder: (context, snapshot) {
                                final loopMode = snapshot.data;
                                if (LoopMode.one == loopMode) {
                                  return const Icon(Icons.repeat,
                                      color: Colors.purpleAccent);
                                } else {
                                  return const Icon(
                                    Icons.repeat,
                                    color: Colors.white,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  showPlaylistdialog(context, playListPro) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 67, 38, 128),
            title: const Center(
              child: Text(
                "choose your playlist",
                style: TextStyle(color: Colors.white, fontFamily: 'poppins'),
              ),
            ),
            content: SizedBox(
              height: 130,
              width: double.maxFinite,
              child: ValueListenableBuilder(
                  valueListenable:
                      Hive.box<FavModel>('playlistDb').listenable(),
                  builder: (BuildContext context, Box<FavModel> musicList,
                      Widget? child) {
                    return Hive.box<FavModel>('playlistDb').isEmpty
                        ? Center(
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: Image.asset(
                                      'assets/Image/No-Emoji-GIF-No-Emoji-Discover-unscreen.gif'),
                                ),
                                const Positioned(
                                  right: 30,
                                  left: 40,
                                  bottom: 10,
                                  child: Center(
                                    child: Text(
                                      'No Playlist found!',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          fontFamily: 'poppins'),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: musicList.length,
                            itemBuilder: (context, index) {
                              final data = musicList.values.toList()[index];

                              return Card(
                                color: const Color.fromARGB(255, 51, 2, 114),
                                shadowColor: Colors.purpleAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side:
                                        const BorderSide(color: Colors.white)),
                                child: ListTile(
                                  title: Text(
                                    data.name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'poppins'),
                                  ),
                                  trailing: const Icon(
                                    Icons.playlist_add,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    songAddToPlaylist(
                                        widget.songModelList[currentIndex],
                                        data,
                                        data.name);
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          );
                  }),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    newplaylist(context, _formKey, playListPro);
                  },
                  child: const Text(
                    'New Playlist',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.bold),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'cancel',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }

  void songAddToPlaylist(SongModel data, datas, String name) {
    if (!datas.isValueIn(data.id)) {
      datas.add(data.id);
      final snackbar1 = SnackBar(
          duration: const Duration(milliseconds: 850),
          backgroundColor: Colors.black,
          content: Text(
            'Song added to $name',
            style: const TextStyle(color: Colors.greenAccent),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar1);
    } else {
      final snackbar2 = SnackBar(
          duration: const Duration(milliseconds: 850),
          backgroundColor: Colors.black,
          content: Text(
            'Song already added in $name',
            style: const TextStyle(color: Colors.redAccent),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar2);
    }
  }

  Future newplaylist(BuildContext context, formKey, playListPro) {
    return showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        backgroundColor: const Color.fromARGB(255, 52, 6, 105),
        children: [
          const SimpleDialogOption(
            child: Text(
              'New to Playlist',
              style: TextStyle(
                  fontFamily: 'poppins',
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SimpleDialogOption(
            child: Form(
              key: formKey,
              child: TextFormField(
                textAlign: TextAlign.left,
                controller: nameController,
                maxLength: 15,
                decoration: InputDecoration(
                    counterStyle: const TextStyle(
                        color: Colors.white, fontFamily: 'poppins'),
                    fillColor: Colors.white.withOpacity(0.7),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.only(left: 15, top: 5)),
                style: const TextStyle(
                    fontFamily: 'poppins',
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your playlist name";
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  nameController.clear();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveButtonPressed(context, playListPro);
                  }
                },
                child: const Text(
                  'Create',
                  style: TextStyle(
                      fontFamily: 'poppins',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> saveButtonPressed(context, playListPro) async {
    final name = nameController.text.trim();
    final music = FavModel(name: name, songId: []);
    final datas =
        playListPro.playlistDb.values.map((e) => e.name.trim()).toList();
    if (name.isEmpty) {
      return;
    } else if (datas.contains(music.name)) {
      const snackbar3 = SnackBar(
          duration: Duration(milliseconds: 750),
          backgroundColor: Colors.black,
          content: Text(
            'playlist already exist',
            style: TextStyle(color: Colors.redAccent),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar3);
      Navigator.of(context).pop();
    } else {
      playListPro.addPlaylist(music);
      const snackbar4 = SnackBar(
        duration: Duration(milliseconds: 750),
        backgroundColor: Colors.black,
        content: Text(
          'playlist created successfully',
          style: TextStyle(color: Colors.white),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar4);
      Navigator.pop(context);
      nameController.clear();
    }
  }

  // ignore: non_constant_identifier_names

}
