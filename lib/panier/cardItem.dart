import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final QueryDocumentSnapshot produit;
  late final int quantity;

  CartItem({required this.produit, required this.quantity});
}

class Cart {
  final String userId;
  List<CartItem> items = [];

  Cart(this.userId);

  Future<void> addItem(QueryDocumentSnapshot produit, int quantity) async {
    int stock = produit['stock'];

    if (quantity > stock) {
      print("Quantité demandée dépasse le stock disponible.");
      throw Exception("Quantité demandée dépasse le stock disponible.");
    }

    var cartRef = FirebaseFirestore.instance.collection('carts').doc(userId).collection('items');
    var existingItemSnapshot = await cartRef.where('produitId', isEqualTo: produit.id).get();

    if (existingItemSnapshot.docs.isNotEmpty) {
      var doc = existingItemSnapshot.docs.first;
      await doc.reference.update({
        'quantity': (doc['quantity'] as int) + quantity,
      });
    } else {
      await cartRef.add({
        'produitId': produit.id,
        'nomProduit': produit['nomProduit'],
        'prix': produit['prix'],
        'quantity': quantity,
      });
    }
  }


  Future<void> clear() async {
    final cartRef = FirebaseFirestore.instance.collection('carts').doc(userId);
    final snapshot = await cartRef.collection('items').get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    items.clear();
  }

  Future<List<CartItem>> getItems() async {
    if (userId.isEmpty) {
      return [];
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('carts')
        .doc(userId)
        .collection('items')
        .get();

    return snapshot.docs.map((doc) {
      return CartItem(
        produit: doc,
        quantity: doc['quantity'] as int,
      );
    }).toList();
  }
}
