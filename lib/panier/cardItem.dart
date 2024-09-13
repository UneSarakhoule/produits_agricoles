import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final QueryDocumentSnapshot produit;
  late final int quantity;
  final String? photos;

  CartItem({
    this.photos,
    required this.produit,
    required this.quantity
  });
}

class Cart {
  final String userId;
  List<CartItem> items = [];

  Cart(this.userId);

  Future<void> addItem(QueryDocumentSnapshot produit, int quantity) async {
    int stock = int.tryParse(produit['stock'].toString()) ?? 0;

    if (quantity > stock) {
      throw Exception("Quantité demandée dépasse le stock disponible.");
    }

    Map<String, dynamic> productData = produit.data() as Map<String, dynamic>;

    var cartRef = FirebaseFirestore.instance
        .collection('Cart')
        .doc(userId)
        .collection('items');
    var existingItemSnapshot = await cartRef.where('produitId', isEqualTo: produit.id).get();

    String? photos = productData.containsKey('photos') ? productData['photos'] : null;

    if (existingItemSnapshot.docs.isNotEmpty) {
      var doc = existingItemSnapshot.docs.first;
      await doc.reference.update({
        'quantity': (doc['quantity'] as int) + quantity,
      });
    } else {
      await cartRef.add({
        'produitId': produit.id,
        'nomProduit': productData['nomProduit'],
        'prix': productData['prix'],
        'quantity': quantity,
        'photos': photos, // Ajout de l'URL de l'image
      });
    }

    // Mise à jour du stock du produit
    await _updateProductStock(produit.id, stock - quantity);
  }

  Future<void> _updateProductStock(String produitId, int newStock) async {
    var produitRef = FirebaseFirestore.instance.collection('Produits').doc(produitId);
    await produitRef.update({'stock': newStock});
  }

  Future<void> clear() async {
    final cartRef = FirebaseFirestore.instance.collection('Cart').doc(userId);
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
        .collection('Cart')
        .doc(userId)
        .collection('items')
        .get();

    return snapshot.docs.map((doc) {
      return CartItem(
        produit: doc,
        quantity: doc['quantity'] as int,
        photos: doc.data().containsKey('photos') ? doc['photos'] : null, // Récupération de l'image
      );
    }).toList();
  }
}

