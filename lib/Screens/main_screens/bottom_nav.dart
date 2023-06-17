import 'package:flutter/material.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../Provider/bottom_nav_bar/bottom_nav.dart';
import 'Home/Home_Screen.dart';
import 'Playlist/playlist_screen.dart';
import 'Settings/settings.dart';
import 'favorites/favorite_screen.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  // ignore: non_constant_identifier_names
  final Pages = [
    HomeScreen(),
    const FavouriteScreen(),
    const PlaylistScreen(),
    const Settings()
  ];

  @override
  Widget build(BuildContext context) {
    var bottomProvider = Provider.of<BottomNavProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 16, 80),
      body: SafeArea(
        child: Consumer<BottomNavProvider>(
          builder: (context, value, child) => Pages[value.currentSelectedIndex],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              // border: Border.all(color: Colors.deepPurple, width: 2),

              borderRadius: BorderRadius.circular(40)),
          child: Consumer<BottomNavProvider>(
            builder: (context, value, child) => GNav(
                tabBorderRadius: 150,
                tabBackgroundColor: const Color.fromARGB(255, 183, 75, 181),
                gap: 5,
                haptic: true,
                padding: const EdgeInsets.all(12),
                activeColor: Colors.white,
                color: Colors.white,
                onTabChange: (index) {
                  value.bottomSwitching(index);
                },
                tabs: const [
                  GButton(
                    icon: Icons.headphones_outlined,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.favorite_outline,
                    text: 'Favorite',
                  ),
                  GButton(
                    icon: Icons.playlist_add_outlined,
                    text: 'Playlist',
                  ),
                  GButton(
                    icon: Icons.settings_outlined,
                    text: 'Settings',
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
