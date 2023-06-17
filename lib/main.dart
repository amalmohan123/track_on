import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'Database/fav_database.dart';
import 'Model/fav_model.dart';
import 'Model/fav_model_gener.dart';
import 'Provider/Now_playing_provider/now_playing_provider.dart';
import 'Provider/Onbarding_provider/Onboarding_provider.dart';
import 'Provider/Search_provider/search_provider.dart';
import 'Provider/Song_model_provider.dart';
import 'Provider/bottom_nav_bar/bottom_nav.dart';
import 'Provider/home_page_provider/Home_provider.dart';
import 'Screens/mini_screens/splash_screen.dart';
import 'database/playlist_db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Hive.isAdapterRegistered(FavModelAdapter().typeId)) {
    Hive.registerAdapter(FavModelAdapter());
  }

  await Hive.initFlutter();
  await Hive.openBox<int>('FavoriteDB');
  await Hive.openBox<FavModel>('playlistDb');

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider(create: (context) => SongModelProvider()),
        ListenableProvider(create: (context) => HomePageProvider()),
        ListenableProvider(create: (context) => NowProvider()),
        ListenableProvider(create: (context) => BottomNavProvider()),
        ListenableProvider(create: (context) => OnBoardingProvider()),
        ListenableProvider(create: (context) => SearchProvider()),
        ListenableProvider(create: (context) => PlaylistDb()),
        ListenableProvider(create: (context) => FavoriteDb()),
      ],
      child: MaterialApp(
          title: 'TrackOn music app ',
          debugShowCheckedModeBanner: false,
          home: SplashScreen()),
    );
  }
}
