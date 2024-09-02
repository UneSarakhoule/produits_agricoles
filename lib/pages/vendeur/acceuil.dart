import 'package:agricol/models/drawer.dart';
import 'package:flutter/material.dart';
import 'package:agricol/models/constants.dart';

import '../../models/logo.dart';

class AcceuilVendeur extends StatefulWidget {
  const AcceuilVendeur({super.key});

  @override
  State<StatefulWidget> createState() => _AcceuilVendeur();
}

class _AcceuilVendeur extends State<AcceuilVendeur> {
  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Appbar(),
      drawer: DrawerVendeur(),
      backgroundColor: myConstants.thirtyColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espace entre les éléments
              children: [
                const Text(
                  'DASHBOARD',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20), // Espace entre DASHBOARD et la barre de recherche
                Expanded(
                  child: Container(
                    height: 43,
                    child: SearchBar(
                      leading: Row(
                        children: [
                          const Icon(Icons.search_sharp),
                          //LA LIGNE
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            height: 26.0,
                            width: 1.0,
                            color: myConstants.gris2,
                          ),
                        ],
                      ),
                      hintText: 'Rechercher ...',
                      backgroundColor: WidgetStatePropertyAll(myConstants.thirtyColor),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
