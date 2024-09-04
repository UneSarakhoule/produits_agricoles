import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/constants.dart';
import 'package:agricol/pages/clients/DetailsProduit.dart';

import '../../widget/produitsAcceuil.dart';

class ProductListByCategory extends StatelessWidget {
  final String category;

  const ProductListByCategory({required this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    return Scaffold(
      appBar: AppBar(
        title: Text('Produits - $category/kg'),
        backgroundColor: myConstants.thirtyColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Produits')
            .where('categories', isEqualTo: category) // Filtrer par catégorie
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var produits = snapshot.data!.docs;

          return ListView.builder(
            itemCount: produits.length,
            itemBuilder: (context, index) {
              var produit = produits[index];
              return ProductTile(
                key: ValueKey(produit.id), // Ajouter une clé ici
                produit: produit,
              );
            },
          );
        },
      ),
    );
  }
}
