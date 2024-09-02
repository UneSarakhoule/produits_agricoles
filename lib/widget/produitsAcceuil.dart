import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/constants.dart';
import 'package:agricol/pages/clients/DetailsProduit.dart';

class Produitsacceuil extends StatefulWidget {
  const Produitsacceuil({super.key});

  @override
  State<Produitsacceuil> createState() => _ProduitsacceuilState();
}

class _ProduitsacceuilState extends State<Produitsacceuil> {
  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Réduction du padding autour du texte "Nos produits"
          const Padding(
            padding: EdgeInsets.only(top: 5.0, left: 10.0, bottom: 5.0),
            child: Text(
              'Nos produits',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Affichage de la liste des produits
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Produits')
                  .limit(10) // Limite à 10 produits
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
                      key: ValueKey(produit.id),
                      produit: produit,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductTile extends StatefulWidget {
  final QueryDocumentSnapshot produit;
  const ProductTile({required this.produit, super.key});

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> with AutomaticKeepAliveClientMixin<ProductTile> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      // Réduction des marges pour rapprocher les produits les uns des autres
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      color: Constants().thirtyColor,
      child: ListTile(
        key: ValueKey(widget.produit.id),
        contentPadding: const EdgeInsets.all(8.0),
        leading: Image.network(
          widget.produit['photos'],
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        title: Text(widget.produit['nomProduit'], style: const TextStyle(fontSize: 18)),
        subtitle: Text('${widget.produit['prix']} FCFA'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetails(produit: widget.produit),
            ),
          );
        },
      ),
    );
  }
}
