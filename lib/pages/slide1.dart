import 'package:agricol/pages/slide3.dart';
import 'package:flutter/material.dart';
import 'package:agricol/models/constants.dart';
import 'dart:async';

class Slide1 extends StatefulWidget {
  const Slide1({super.key});

  @override
  State<StatefulWidget> createState() => _Slide();
}

class _Slide extends State<Slide1> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Offset>? _animation;

  @override
  void initState() {
    super.initState();

    // Initialisation de l'animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeOut,
    ));

    // Démarrage de l'animation après un délai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(milliseconds: 100), () {
        _controller?.forward().whenComplete(() {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Slide3()),
          );
        });
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    return Scaffold(
      backgroundColor: myConstants.primaryColor,
      body: Stack(
        children: [
          const Slide3(), // Slide2 est en dessous de Slide1 et est révélé progressivement
          SlideTransition(
            position: _animation!,
            child: Container(
              color: myConstants.primaryColor, // Couleur de fond de Slide1
              child: Center(
                child: Text(
                  ' ', // Contenu de Slide1
                  style: TextStyle(color: myConstants.thirtyColor, fontSize: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
