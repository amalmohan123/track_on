import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../Database/fav_database.dart';


class FavoritesButton extends StatelessWidget {
  const FavoritesButton({super.key, required this.songFavorite});
  final SongModel songFavorite;

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteDb>(
      builder: (context, value, child) {
        return IconButton(
          onPressed: () {
            if (value.isFavor(songFavorite)) {
              value.delete(songFavorite.id);
              const snackBar = SnackBar(
                content: Text('Song Added to Favorite'),
                duration: Duration(seconds: 1),
                backgroundColor: Color.fromARGB(255, 20, 5, 46),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          icon: Icon(
            value.isFavor(songFavorite)
                ? Icons.favorite
                : Icons.favorite_outline,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
