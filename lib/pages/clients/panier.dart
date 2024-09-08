import 'package:flutter/material.dart';
import '../../models/addCart.dart';
import '../../panier/cardService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import '../../models/constants.dart';

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
    cart = Cart(); // Initialisez votre panier
    CartService(cart).loadCartFromFirestore().then((_) {
      print('Cart loaded');
    });
  }

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
    CartService(cart).saveCartToFirestore();
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

      setState(() {
        cart.items.clear();
      });

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
                ? Center(child: Text('Votre panier est vide'))
                : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                var item = cart.items[index];
                var price = int.tryParse(item.produit['prix'].toString()) ?? 0;
                var itemTotalPrice = price * item.quantity;

                return ListTile(
                  leading: Image.network(item.produit['photos']),
                  title: Text(item.produit['nomProduit']),
                  subtitle: Text('Prix: ${item.produit['prix']} FCFA\nQuantité: ${item.quantity}'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_shopping_cart),
                    onPressed: () => removeItem(index),
                  ),
                  isThreeLine: true,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total: $totalPrice FCFA',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: placeOrder,
                  child: Text('Passer la commande'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
