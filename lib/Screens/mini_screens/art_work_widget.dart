import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../Provider/Song_model_provider.dart';

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: context.watch<SongModelProvider>().id,
      type: ArtworkType.AUDIO,
      artworkHeight: 200,
      artworkWidth: 200,
      keepOldArtwork: true,
      artworkFit: BoxFit.cover,
      nullArtworkWidget: const CircleAvatar(
        radius: 120,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage(
          'assets/Image/WhatsApp_Image_2023-03-17_at_10.24.28-removebg-preview.png',
        ),
      ),
    );
  }
}
