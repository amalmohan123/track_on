import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../Controller/all_song_controller.dart';
import '../../../Database/fav_database.dart';
import '../../mini_screens/PlayScreen.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteDb>(
      builder: (context, value, child) {
        return Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 36, 16, 80),
          ),
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                'Favourite songs',
                style: GoogleFonts.aclonica(fontSize: 20),
              ),
            ),
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Consumer<FavoriteDb>(
                          builder: (context, value, child) {
                            if (value.favoriteSongs.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 70, left: 10),
                                child: Center(
                                  child: Text(
                                    'No Favorite Songs',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: 400,
                                width: double.infinity,
                                child: ListView.builder(
                                  itemBuilder: ((context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 183, 183, 247),
                                                  width: 1.4),
                                              color: Colors.black12),
                                          child: ListTile(
                                            iconColor: Colors.white,
                                            selectedColor: Colors.purpleAccent,
                                            leading: QueryArtworkWidget(
                                              id: value.favoriteSongs[index].id,
                                              type: ArtworkType.AUDIO,
                                              nullArtworkWidget:
                                                  const CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                radius: 27,
                                                backgroundImage: AssetImage(
                                                  'assets/Images/WhatsApp_Image_2023-03-17_at_10.24.28-removebg-preview.png',
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              value.favoriteSongs[index]
                                                  .displayNameWOExt,
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontFamily: 'poppins',
                                                  color: Colors.white),
                                            ),
                                            subtitle: Text(
                                              value.favoriteSongs[index].artist
                                                  .toString(),
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontFamily: 'poppins',
                                                  fontSize: 12,
                                                  color: Colors.blueGrey),
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(
                                                Icons.heart_broken,
                                                color: Colors.purple,
                                              ),
                                              onPressed: () {
                                                value.delete(value
                                                    .favoriteSongs[index].id);
                                                const snackbar = SnackBar(
                                                  content: Text(
                                                    'Song Deleted From your Favourites',
                                                  ),
                                                  duration:
                                                      Duration(seconds: 1),
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 20, 5, 46),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackbar);
                                              },
                                            ),
                                            onTap: () {
                                              List<SongModel> favoriteList = [
                                                ...value.favoriteSongs
                                              ];
                                              GetAllSongController.audioPlayer
                                                  .stop();
                                              GetAllSongController.audioPlayer
                                                  .setAudioSource(
                                                      GetAllSongController
                                                          .createSongList(
                                                              favoriteList),
                                                      initialIndex: index);
                                              GetAllSongController.audioPlayer
                                                  .play();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlayScreen(
                                                          songModelList:
                                                              favoriteList),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  itemCount: value.favoriteSongs.length,
                                ),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
