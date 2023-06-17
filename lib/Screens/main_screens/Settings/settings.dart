import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_on/Screens/main_screens/Settings/terms.dart';
import '../../../Database/fav_database.dart';
import '../../../Model/fav_model.dart';
import '../../mini_screens/splash_screen.dart';
import 'About.dart';
import 'Privacy.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 85,
        title: Center(
          child: Text(
            'Settings',
            style: GoogleFonts.aclonica(fontSize: 20),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 36, 16, 80),
      body: Padding(
        padding: const EdgeInsets.only(left: 54, top: 50),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                height: 55,
                width: 300,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 61, 28, 104),
                  border: Border.all(
                      color: const Color.fromARGB(255, 81, 87, 138),
                      width: 2.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 35),
                      child: Icon(Icons.info_outline, color: Colors.white),
                    ),
                    Text(
                      'About Track On',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) {
                      return const About();
                    }),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              child: Container(
                height: 55,
                width: 300,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 61, 28, 104),
                  border: Border.all(
                      color: const Color.fromARGB(255, 81, 87, 138),
                      width: 2.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 35),
                      child:
                          Icon(Icons.privacy_tip_outlined, color: Colors.white),
                    ),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const Privacy();
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              child: Container(
                height: 55,
                width: 300,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 61, 28, 104),
                  border: Border.all(
                      color: const Color.fromARGB(255, 81, 87, 138),
                      width: 2.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 35),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Terms and Conditions',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const Terms_And_Conditions();
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              child: Container(
                height: 55,
                width: 300,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 61, 28, 104),
                  border: Border.all(
                      color: const Color.fromARGB(255, 81, 87, 138),
                      width: 2.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 35),
                      child: Icon(Icons.restore, color: Colors.white),
                    ),
                    Text(
                      'Reset',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              onTap: () {
                resetalert(context);
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
                child: Container(
                  height: 55,
                  width: 300,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 61, 28, 104),
                    border: Border.all(
                        color: const Color.fromARGB(255, 81, 87, 138),
                        width: 2.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 35),
                        child: Icon(Icons.share, color: Colors.white),
                      ),
                      Text(
                        'Share TrackOn',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                onTap: () {}),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void resetalert(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 52, 6, 105),
          title: const Text(
            'Reset TrackOn',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text('Are you sure you want to reset this application',
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'No',
                style: TextStyle(
                    color: Colors.purpleAccent, fontFamily: 'poppins'),
              ),
            ),
            TextButton(
              onPressed: () async {
                final sharedprifes = await SharedPreferences.getInstance();
                await sharedprifes.clear();

                // final musicDb = Hive.openBox<FavModel>('FavoriteDB');

                Provider.of<FavoriteDb>(context, listen: false).clear();

                final playlistDb = Hive.box<FavModel>('playlistDb');
                await playlistDb.clear();

                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    return SplashScreen();
                  },
                ), (route) => false);
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                    color: Colors.purpleAccent, fontFamily: 'poppins'),
              ),
            )
          ],
        );
      },
    );
  }
}
