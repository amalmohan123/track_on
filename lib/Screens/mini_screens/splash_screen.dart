import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main_screens/bottom_nav.dart';
import 'OnbordingScreen/Onbording_screen.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  late SharedPreferences sharedPreferences;

  dynamic savedValue;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gotoHome(context);
      getDataFromSharedPreference();
    });
    getDataFromSharedPreference();
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 28, 13, 61),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Image(
                  image: AssetImage('assets/Image/logo.gif'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> gotoHome(context) async {
    await Future.delayed(const Duration(seconds: 5));
    if (savedValue == null) {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return OnBoardingScreen();
      }), (route) => false);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return BottomNavBar();
      }), (route) => false);
    }
  }

  Future<void> getDataFromSharedPreference() async {
    final sharedprifes = await SharedPreferences.getInstance();

    savedValue = sharedprifes.getInt('enterCount');
  }
}
