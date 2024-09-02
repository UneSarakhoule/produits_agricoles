import 'package:agricol/pages/connexion2.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:agricol/models/constants.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:page_transition/page_transition.dart';

class Slide3 extends StatefulWidget {
  const Slide3({super.key});

  @override
  _Slide3State createState() => _Slide3State();
}

class _Slide3State extends State<Slide3> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Constants myConstants;
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    myConstants = Constants();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Stack(
                children: [
                  _buildFrame(_animation.value),
                  // Ajouter un flou d'arrière-plan
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                  // Titre principal
                  Positioned(
                    left: 24,
                    top: 455,
                    child: SizedBox(
                      width: 382,
                      height: 77,
                      child: Text(
                        'AGRIINNOVATE',
                        style: TextStyle(
                          color: myConstants.color6,
                          fontSize: 41,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  // Titre secondaire
                  Positioned(
                    left: 24,
                    top: 545,
                    child: SizedBox(
                      width: 300,
                      child: Text(
                        'Nous sommes heureux de vous compter parmi nous',
                        style: TextStyle(
                          color: myConstants.color6,
                          fontSize: 20,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  // Le bouton
                  // Positioned(
                  //   left: 24,
                  //   top: 631,
                  //   child: Container(
                  //     width: 300,
                  //     height: 55,
                  //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  //     decoration: ShapeDecoration(
                  //       color: myConstants.primaryColor,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(28),
                  //       ),
                  //     ),
                  //     child: const Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         Text(
                  //           'REJOIGNEZ-NOUS',
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 20,
                  //             fontFamily: 'Calibri',
                  //             fontWeight: FontWeight.w700,
                  //             height: 0,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.86,
                    left: 24,
                    right: 24,
                    child: SwipeableButtonView(
                      buttonText: 'REJOIGNEZ-NOUS',
                      buttonWidget: Container(
                        child: Icon(Icons.arrow_forward_ios_rounded,
                          color: myConstants.primaryColor,
                        ),
                      ),
                      activeColor: myConstants.primaryColor,
                      isFinished: isFinished,
                      onWaitingProcess: () {
                        Future.delayed(Duration(seconds: 2), () {
                          setState(() {
                            isFinished = true;
                          });
                        });
                      },
                      onFinish: () async {
                        await Navigator.push(context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: const Connexion2()
                            )
                        );

                        setState(() {
                          isFinished = false;
                        });
                      },
                    ),
                  ),

                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFrame(double progress) {
    if (progress < 0.25) {
      return _buildFrame1(progress / 0.25);
    } else if (progress < 0.5) {
      return _buildFrame2((progress - 0.25) / 0.25);
    } else if (progress < 0.75) {
      return _buildFrame3((progress - 0.5) / 0.25);
    } else {
      return _buildFrame4((progress - 0.75) / 0.25);
    }
  }

  Widget _buildFrame1(double t) {
    return Stack(
      children: [
        _buildBoule(
          left: 213 + (109 - 213) * t,
          top: 462 + (369 - 462) * t,
          width: 150,
          height: 150,
          color: myConstants.color5.withOpacity(0.4),
          blurSigma: 20.0,
        ),
        _buildBoule(
          left: 50 + (100 - 50) * t,
          top: 100 + (200 - 100) * t,
          width: 436,
          height: 436,
          color: myConstants.color4.withOpacity(0.4),
          blurSigma: 20.0,
        ),
        _buildBoule(
          left: 300 + (200 - 300) * t,
          top: 600 + (500 - 600) * t,
          width: 213,
          height: 213,
          color: myConstants.color3.withOpacity(0.4),
          blurSigma: 20.0,
        ),
      ],
    );
  }

  Widget _buildFrame2(double t) {
    return Stack(
      children: [
        _buildBoule(
          left: 109 + (-233 - 109) * t,
          top: 369 + (578 - 369) * t,
          width: 150,
          height: 150,
          color: myConstants.color5.withOpacity(0.4),
          blurSigma: 20.0,
        ),
        _buildBoule(
          left: 100 + (150 - 100) * t,
          top: 200 + (300 - 200) * t,
          width: 436,
          height: 436,
          color: myConstants.color4.withOpacity(0.4),
          blurSigma: 20.0,
        ),
        _buildBoule(
          left: 200 + (100 - 200) * t,
          top: 500 + (400 - 500) * t,
          width: 213,
          height: 213,
          color: myConstants.color3.withOpacity(0.4),
          blurSigma: 20.0,
        ),
      ],
    );
  }

  Widget _buildFrame3(double t) {
    return Stack(
      children: [
        _buildBoule(
          left: -233 + (146 + 233) * t,
          top: 578 + (0 - 578) * t,
          width: 150,
          height: 150,
          color: myConstants.color5.withOpacity(0.4),
          blurSigma: 20.0,
        ),
        _buildBoule(
          left: 150 + (50 - 150) * t,
          top: 300 + (400 - 300) * t,
          width: 436,
          height: 436,
          color: myConstants.color4.withOpacity(0.4),
          blurSigma: 20.0,
        ),
        _buildBoule(
          left: 100 + (200 - 100) * t,
          top: 400 + (300 - 400) * t,
          width: 213,
          height: 213,
          color: myConstants.color3.withOpacity(0.4),
          blurSigma: 20.0,
        ),
      ],
    );
  }

  Widget _buildFrame4(double t) {
    return Stack(
      children: [
        _buildBoule(
          left: 146 + (-48 - 146) * t,
          top: 0 + (-50 - 0) * t,
          width: 150,
          height: 150,
          color: myConstants.color5.withOpacity(0.4),
          blurSigma: 20.0,
        ),
        _buildBoule(
          left: 50 + (100 - 50) * t,
          top: 400 + (300 - 400) * t,
          width: 436,
          height: 436,
          color: myConstants.color4.withOpacity(0.4),
          blurSigma: 20.0,
        ),
        _buildBoule(
          left: 200 + (300 - 200) * t,
          top: 300 + (400 - 300) * t,
          width: 213,
          height: 213,
          color: myConstants.color3.withOpacity(0.4),
          blurSigma: 20.0,
        ),
      ],
    );
  }

  Widget _buildBoule({
    required double left,
    required double top,
    required double width,
    required double height,
    required Color color,
    required double blurSigma,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10.0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
