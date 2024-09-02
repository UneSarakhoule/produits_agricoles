import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Listeproduit extends StatefulWidget {
  const Listeproduit({super.key});

  @override
  State<Listeproduit> createState() => _ListeproduitState();
}

class _ListeproduitState extends State<Listeproduit> {

  // Récupère les produits ajoutés par l'utilisateur actuel
  Stream<QuerySnapshot> _getUserProducts() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('Produits')
          .where('userId', isEqualTo: user.uid)
          .snapshots();
    }
    return const Stream.empty();
  }

  // Fonction pour supprimer un produit
  Future<void> _deleteProduct(String productId) async {
    await FirebaseFirestore.instance
        .collection('Produits')
        .doc(productId)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produit supprimé')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Produits'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getUserProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erreur de chargement des produits'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucun produit ajouté'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot product = snapshot.data!.docs[index];
              String productId = product.id;
              String productName = product['nomProduit'];
              String productDescription = product['description'];

              return ListTile(
                title: Text(productName),
                subtitle: Text(productDescription),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Naviguer vers la page de modification du produit
                        Navigator.pushNamed(context, '/modifierProduit', arguments: product);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteProduct(productId);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
