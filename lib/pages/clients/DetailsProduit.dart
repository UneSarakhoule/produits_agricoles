import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agricol/models/addCart.dart';
import '../../models/constants.dart';

class ProductDetails extends StatefulWidget {
  final QueryDocumentSnapshot produit;

  const ProductDetails({required this.produit, Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _quantity = 1; // Quantité initiale

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    return Scaffold(
      backgroundColor: myConstants.thirtyColor,
      appBar: AppBar(
        title: Text(widget.produit['nomProduit']),
        backgroundColor: myConstants.thirtyColor,
        leading:
        IconButton(
          onPressed: (){
            Navigator.pushNamed(context, '/bottomNavigation');},
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section gauche avec les détails
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.produit['nomProduit'],
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${widget.produit['prix']} FCFA',
                        style: TextStyle(
                            fontSize: 20, color: myConstants.vert2),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Stock: ${widget.produit['stock']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < widget.produit['etoiles']
                                ? Icons.star
                                : Icons.star_border,
                            color: myConstants.yellow,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                // Photo du produit à droite
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.produit['photos'],
                    height: 200,
                    width: 150, // Vous pouvez ajuster la largeur ici
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Description en dessous des deux sections
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(widget.produit['description']),
            SizedBox(height: 20),
            // Section des boutons (Quantité et Ajouter au panier)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantité:',
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (_quantity > 1) {
                          setState(() {
                            _quantity--;
                          });
                        }
                      },
                    ),
                    Text(
                      '$_quantity',
                      style: TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logique pour ajouter le produit au panier avec la quantité sélectionnée
                  //print("Produit ajouté au panier : ${widget.produit.id} avec quantité $_quantity");
                  cart.addItem(widget.produit, _quantity);

                  // Optionnel : Afficher un message de confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Produit ajouté au panier")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: myConstants.vert2,
                ),
                child: Text('Ajouter au panier'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
