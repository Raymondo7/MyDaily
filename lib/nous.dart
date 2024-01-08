import 'package:flutter/material.dart';

import 'constants.dart';

class APropos extends StatelessWidget {
  const APropos({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primColor,
        foregroundColor: secColor,
        centerTitle: true,
        title: Text(
          'A Propos de Nous',
          style: stylish(30, secColor),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_alt_rounded, size: 85, color: primColor),
            Text(
              'Notre mission chez KVRCorporation est de simplifier votre quotidien. Avec une passion pour l\'innovation, nous créons des solutions intuitives pour vous aider à rester organisé, connecté et inspiré. Explorez avec nous un monde où la technologie rencontre la convivialité',
              style: stylish(25, Colors.black),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Text('raymondkenavo@gmail.com', style: stylish(20, Colors.black)),
            Text('+228 99 41 75 64', style: stylish(25, primColor)),
          ],
        ),
      ),
    );
  }
}
