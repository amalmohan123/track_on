import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../../Controller/all_song_controller.dart';
import '../../../../Provider/Song_model_provider.dart';
import '../../../mini_screens/PlayScreen.dart';
import '../Home_Screen.dart';
import '../menu_Button.dart';


class GridViewType extends StatelessWidget {
  const GridViewType({Key? key, required this.allSongs, required this.items})
      : super(key: key);

  final List<SongModel> allSongs;
  // ignore: prefer_typing_uninitialized_variables
  final items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.only(left: 15, right: 15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: (1 / 1),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: items.data!.length,
        itemBuilder: ((context, index) {
          allSongs.addAll(items.data!);
          return GestureDetector(
            onTap: (() {
              context.read<SongModelProvider>().setId(items.data![index].id);
              GetAllSongController.audioPlayer.setAudioSource(
                  GetAllSongController.createSongList(items.data!),
                  initialIndex: index);
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
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                  border: Border.all(
                      color: const Color.fromARGB(255, 203, 203, 252), width: 1.4),
                ),
                child: GridTile(
                  header: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FavOrPlayMenuButton(
                          songFavorite: startSong[index], findex: index),
                    ],
                  ),
                  footer: Container(
                    decoration: const BoxDecoration(
                        // border: Border.all(
                        //   color: Colors.black,

                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(22),
                            bottomRight: Radius.circular(22)),
                        color: Colors.black26),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, left: 15),
                          child: Text(
                            items.data![index].displayNameWOExt,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                    ),
                  ),
                  child: QueryArtworkWidget(
                    artworkFit: BoxFit.fitHeight,
                    nullArtworkWidget: Image.asset(
                      'assets/Image/WhatsApp_Image_2023-03-17_at_10.24.28-removebg-preview.png',
                      fit: BoxFit.fitHeight,
                    ),
                    id: items.data![index].id,
                    type: ArtworkType.AUDIO,
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
