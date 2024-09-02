import 'package:agricol/widget/produitsAcceuil.dart';
import 'package:flutter/material.dart';
import 'package:agricol/pages/clients/categories.dart';
import 'package:agricol/models/drawerClient.dart';
import 'package:agricol/models/constants.dart';
import 'package:agricol/models/logo.dart';

class AcceuilClient extends StatelessWidget {
  const AcceuilClient({super.key});

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: myConstants.thirtyColor,
      appBar: Appbar(),
      drawer: Drawerclient(),
      body: const Column(
        children: [
          // Ajout des catégories en haut
          Expanded(
            child: Categories(),
          ),
          //Ajout des produits en dessous
          Expanded(
            child: Produitsacceuil(),
          ),
        ],
      ),
    );
  }
}
