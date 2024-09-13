import 'package:flutter/material.dart';
import '../../models/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../panier/cardItem.dart';

class Panier extends StatefulWidget {
  const Panier({super.key});

  @override
  State<Panier> createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  late Cart cart;

  @override
  void initState() {
    super.initState();
    _checkUserAndLoadCart();
  }

  Future<void> _checkUserAndLoadCart() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        cart = Cart(user.uid); // Initialise le panier avec l'ID utilisateur
      });
      await _loadCartItems(); // Charge les articles du panier
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _loadCartItems() async {
    final items = await cart.getItems();
    setState(() {
      cart.items = items;
    });
  }

  int calculateTotalPrice() {
    int totalPrice = 0;
    for (var item in cart.items) {
      int price = int.tryParse(item.produit['prix'].toString()) ?? 0;
      totalPrice += (price * item.quantity) as int;
    }
    return totalPrice;
  }

  Future<void> removeItem(int index) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final produitId = cart.items[index].produit.id;
      final quantity = cart.items[index].quantity;

      final cartRef = FirebaseFirestore.instance
          .collection('Cart')
          .doc(user.uid)
          .collection('items');

      try {
        // Vérifiez si le document du panier de l'utilisateur existe
        final snapshot = await cartRef.where('produitId', isEqualTo: produitId).get();

        if (snapshot.docs.isEmpty) {
          throw Exception("Le produit n'existe pas dans le panier.");
        }

        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }

        await _updateProductStock(produitId, quantity);

        await _loadCartItems();
      } catch (e) {
        print('Erreur lors de la suppression de l\'article : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la suppression de l'article: $e")),
        );
      }
    }
  }



  Future<void> _updateProductStock(String produitId, int newStock) async {
    var produitRef = FirebaseFirestore.instance.collection('Produits').doc(produitId);
    var produitSnapshot = await produitRef.get();

    if (!produitSnapshot.exists) {
      throw Exception("Le produit n'existe pas dans Firestore.");
    }

    await produitRef.update({'stock': newStock});
  }


  Future<void> placeOrder() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final order = {
        'userId': user.uid,
        'items': cart.items.map((item) => {
          'nomProduit': item.produit['nomProduit'],
          'quantité': item.quantity,
          'prix': item.produit['prix'],
        }).toList(),
        'totalPrice': calculateTotalPrice(),
        'date': DateTime.now(),
      };

      await FirebaseFirestore.instance.collection('commandes').add(order);

      await cart.clear(); // Vide le panier après la commande

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Commande passée avec succès !')),
      );
    } else {
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
                ? Center(child:
                  Text('Votre panier est vide')
                )
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      var item = cart.items[index];
                      var price = int.tryParse(item.produit['prix'].toString()) ?? 0;
                      var itemTotalPrice = price * item.quantity;

                      return ListTile(
                        leading: Image.network(item.produit['photos']),
                        title: Text(item.produit['nomProduit']),
                        subtitle: Text('Quantité: ${item.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('$itemTotalPrice FCFA'),
                            IconButton(
                              icon: Icon(Icons.delete, color: myConstants.red),
                              onPressed: () {
                                removeItem(index);
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
                  onPressed: cart.items.isEmpty ? null : () {
                    placeOrder();
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
