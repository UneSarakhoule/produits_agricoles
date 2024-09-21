import 'package:flutter/material.dart';
import 'package:agricol/models/constants.dart';

class Bienvenue extends StatefulWidget {
  const Bienvenue({super.key});

  @override
  State<StatefulWidget> createState() => _Bienvenue();
}

class _Bienvenue extends State<Bienvenue> {
  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: screenHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: myConstants.primaryColor),
          child: Stack(
            children: [
              // Logo positionné avec un Positionned pour garder la position actuelle
              Positioned(
                left: 120,
                top: 160,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              // Centrage de l'animation GIF
              Positioned(
                left: -35,
                top: 300,
                child: Container(
                  width: 430,
                  height: 251,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/AnimationBienvenue.gif'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
