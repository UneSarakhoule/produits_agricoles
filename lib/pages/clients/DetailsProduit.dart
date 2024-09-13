import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../panier/cardItem.dart'; // Assurez-vous que le chemin est correct

class ProductDetails extends StatefulWidget {
  final QueryDocumentSnapshot produit;

  const ProductDetails({required this.produit, Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _quantity = 1;
  double _rating = 0.0;
  int _totalReviews = 0;

  @override
  void initState() {
    super.initState();
    _fetchProductRating();
  }

  Future<void> _fetchProductRating() async {
    try {
      QuerySnapshot evaluationSnapshot = await FirebaseFirestore.instance
          .collection('Evaluation')
          .where('idProduits', isEqualTo: widget.produit.id)
          .get();

      if (evaluationSnapshot.docs.isNotEmpty) {
        double totalRating = 0.0;
        _totalReviews = evaluationSnapshot.docs.length;

        for (var doc in evaluationSnapshot.docs) {
          totalRating += (doc['note'] as double);
        }

        setState(() {
          _rating = totalRating / _totalReviews;
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des évaluations : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    final user = FirebaseAuth.instance.currentUser;

    // Convertir les champs de 'prix' et 'stock' en entiers
    int prix = int.tryParse(widget.produit['prix'].toString()) ?? 0;
    int stock = int.tryParse(widget.produit['stock'].toString()) ?? 0;

    return Scaffold(
      backgroundColor: myConstants.thirtyColor,
      appBar: AppBar(
        title: Text(widget.produit['nomProduit']),
        backgroundColor: myConstants.thirtyColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/bottomNavigation');
          },
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.produit['nomProduit'],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '$prix FCFA', // Affichage du prix en entier
                        style: TextStyle(fontSize: 20, color: myConstants.vert2),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Stock: $stock', // Affichage du stock en entier
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      RatingBar.builder(
                        initialRating: _rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 30.0,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: myConstants.yellow,
                        ),
                        onRatingUpdate: (rating) {
                          // Cette fonction peut être personnalisée pour permettre aux utilisateurs de donner des avis
                        },
                        ignoreGestures: true,
                      ),
                      SizedBox(height: 8.0),
                      Text('$_rating ($_totalReviews avis)'),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.produit['photos'],
                    height: 200,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(widget.produit['description']),
            SizedBox(height: 20),
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
                        if (_quantity < stock) {
                          setState(() {
                            _quantity++;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    final cart = Cart(user.uid);
                    try {
                      await cart.addItem(widget.produit, _quantity);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Produit ajouté au panier")),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Erreur lors de l'ajout au panier: $e")),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Veuillez vous connecter pour ajouter au panier")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: myConstants.vert2,
                ),
                child: Text('Ajouter au panier'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
