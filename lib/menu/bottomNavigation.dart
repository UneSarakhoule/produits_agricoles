import 'package:agricol/pages/clients/panier.dart';
import 'package:agricol/pages/clients/search.dart';
import 'package:agricol/pages/clients/settings.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../models/constants.dart';
import '../pages/clients/acceuilClient.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    AcceuilClient(),
    Search(),
    Settings(),
    Panier(),
  ];

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    return Scaffold(
      body: _pages[_currentIndex],  // Affiche la page correspondant à l'index sélectionné
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: myConstants.thirtyColor,
        color: myConstants.primaryColor,
        animationDuration: Duration(milliseconds: 300),
        items: [
          Icon(
            Icons.home,
            color: _currentIndex == 0 ? myConstants.vert : myConstants.blackColor,
          ),
          Icon(
            Icons.search,
            color: _currentIndex == 1 ? myConstants.vert : myConstants.blackColor,
          ),
          Icon(
            Icons.settings,
            color: _currentIndex == 2 ? myConstants.vert : myConstants.blackColor,
          ),
          Icon(
            Icons.shopping_basket,
            color: _currentIndex == 3 ? myConstants.vert : myConstants.blackColor,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
