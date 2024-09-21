import 'package:flutter/material.dart';
import '../models/constants.dart';
import 'package:agricol/pages/slide3.dart';
import 'dart:async';

class Slide2 extends StatefulWidget {
  const Slide2({super.key});

  @override
  State<StatefulWidget> createState() => _Slide2State();
}

class _Slide2State extends State<Slide2> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0.0, 0.0), // Commence à la position actuelle
      end: const Offset(0.0, -1.0), // Se termine en haut de l'écran
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linearToEaseOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(milliseconds: 900), () {
        _controller.forward().whenComplete(() {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Slide3()),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    final screenHeight = MediaQuery.of(context).size.height;

    return SlideTransition(
      position: _animation,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: screenHeight,
                color: myConstants.primaryColor,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Première ellipse contenant le GIF
                    Positioned(
                      top: 200,
                      child: SizedBox(
                        width: 400,
                        height: 400,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // L'ellipse blanche
                            Container(
                              width: 300,
                              height: 300,
                              decoration: ShapeDecoration(
                                color: myConstants.thirtyColor,
                                shape: const OvalBorder(),
                              ),
                            ),
                            // Le GIF à l'intérieur de l'ellipse
                            Container(
                              width: 500,
                              height: 500,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage('assets/images/AnimationDebut.gif'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Le trait reliant les deux ellipses
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2,
                      top: 550,
                      child: Transform(
                        transform: Matrix4.identity()..rotateZ(1.57),
                        child: Container(
                          width: 160,
                          height: 4,
                          color: myConstants.thirtyColor,
                        ),
                      ),
                    ),
                    // La deuxième ellipse partiellement visible
                    Positioned(
                      top: 710,
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 188,
                            height: 107,
                            decoration: ShapeDecoration(
                              color: myConstants.thirtyColor,
                              shape: const OvalBorder(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
