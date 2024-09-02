import 'package:flutter/material.dart';
import '../../models/constants.dart';
import '../../models/addCart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class Panier extends StatefulWidget {
  const Panier({super.key});

  @override
  State<Panier> createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  int calculateTotalPrice() {
    int totalPrice = 0;
    for (var item in cart.items) {
      int price = int.tryParse(item.produit['prix'].toString()) ?? 0;
      totalPrice += price * item.quantity;
    }
    return totalPrice;
  }

  void removeItem(int index) {
    setState(() {
      cart.items.removeAt(index);
    });
  }

  Future<void> placeOrder() async {
    // Récupérer l'ID de l'utilisateur actuellement connecté
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final order = {
        'userId': user.uid, // Utiliser l'ID de l'utilisateur connecté
        'items': cart.items.map((item) => {
          'nomProduit': item.produit['nomProduit'],
          'quantité': item.quantity,
          'prix': item.produit['prix'],
        }).toList(),
        'totalPrice': calculateTotalPrice(),
        'date': DateTime.now(),
      };

      // Enregistrer la commande dans Firestore
      await FirebaseFirestore.instance.collection('commandes').add(order);

      // Vider le panier après la commande
      setState(() {
        cart.items.clear();
      });

      // Afficher un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Commande passée avec succès !')),
      );
    } else {
      // Si l'utilisateur n'est pas connecté, afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez vous connecter pour passer une commande.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    
    int totalPrice = calculateTotalPrice();
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/bottomNavigation');
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: cart.items.isEmpty
                ? Center(child: Text('Votre panier est vide'))
                : ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    var item = cart.items[index];
    
                    // Convertir le prix en entier ou en double
                    var price = int.tryParse(item.produit['prix'].toString()) ?? 0;
    
                    // Calculer le prix total pour cet article
                    var itemTotalPrice = price * item.quantity;
    
                    return ListTile(
                      leading: Image.network(item.produit['photos']),
                      title: Text(item.produit['nomProduit']),
                      subtitle: Text('Quantité: ${item.quantity}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('$itemTotalPrice FCFA'), // Afficher le prix total
                          IconButton(
                            icon: Icon(Icons.delete, color: myConstants.red),
                            onPressed: () {
                              removeItem(index); // Supprimer l'article
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Prix Total : $totalPrice FCFA',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    placeOrder(); // Passer la commande
                  },
                  child: Text('Valider le panier'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
