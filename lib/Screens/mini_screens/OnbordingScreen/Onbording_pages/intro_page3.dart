import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 130),
              child: Image.asset(
                'assets/Image/Super Deep Meditation Music_ Relax Mind Body….jpeg',
                height: 230,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Okey',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Lets get you started on an awesome music',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 94, 89, 89)),
            ),
            const Text(
              'adventure',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 94, 89, 89)),
            )
          ],
        ));
  }
}
