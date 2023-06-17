import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 87, 49, 99),
            Color.fromARGB(255, 36, 16, 80),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 85,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 38),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'About TrackOn',
                style: GoogleFonts.aclonica(fontSize: 20),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Text(
              '''Welcome to Track On App, make your life more live. We are dedicated to providing you the very best quality of sound and the music varient, with an emphasis on new features. playlists and favourites,and a rich user experience
                
                Founded in 2023 by Amal P. Track On app is our first major project with a basic performance of music hub and creates a better versions in future. Track On gives you the best music experience that you never had. it includes attractivemode of UI's and good practices.
                
                It gives good quality and had increased the settings to power up the system as well as to provide better music rythms.
                
                We hope you enjoy our music as much as we enjoy offering them to you.If you have any questions or comments, please don't hesitate to contact us.
                
                Sincerely,
                
                AMAL P''',
              style: GoogleFonts.aBeeZee(
                  color: const Color.fromARGB(255, 241, 204, 242),
                  fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
