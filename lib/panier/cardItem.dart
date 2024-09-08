import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final QueryDocumentSnapshot produit;
  late final int quantity;

  CartItem({required this.produit, required this.quantity});
}


class Cart {
  List<CartItem> items = [];

  void addItem(QueryDocumentSnapshot produit, int quantity) {
    int stock = produit['stock'];

    if (quantity > stock) {
      // Afficher un message ou gérer l'erreur
      print("Quantité demandée dépasse le stock disponible.");
      return;
    }

    var existingItemIndex = items.indexWhere((item) => item.produit.id == produit.id);

    if (existingItemIndex != -1) {
      // Mettre à jour la quantité si l'article est déjà dans le panier
      items[existingItemIndex].quantity += quantity;
    } else {
      // Ajouter un nouvel article au panier
      items.add(CartItem(produit: produit, quantity: quantity));
    }
  }

  void clear() {
    items.clear();
  }
}


Cart cart = Cart(); // Instance globale de panier
