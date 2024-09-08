import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/addCart.dart'; // Importez le modèle CartItem et Cart

class CartService {
  final Cart cart;

  CartService(this.cart);

  Future<void> saveCartToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final cartData = cart.items.map((item) => {
        'nomProduit': item.produit['nomProduit'],
        'quantité': item.quantity,
        'prix': item.produit['prix'],
        'photos': item.produit['photos'],
        'stock': item.produit['stock'],
      }).toList();

      await FirebaseFirestore.instance
          .collection('paniers')
          .doc(user.uid)
          .set({'items': cartData}, SetOptions(merge: true));
    }
  }

  Future<void> loadCartFromFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('paniers')
          .doc(user.uid)
          .get();

      if (cartSnapshot.exists) {
        final cartData = cartSnapshot.data()!['items'] as List<dynamic>;

        cart.items = cartData.map((item) => CartItem(
          produit: {
            'nomProduit': item['nomProduit'],
            'prix': item['prix'],
            'photos': item['photos'],
            'stock': item['stock'],
          },
          quantity: item['quantité'],
        )).toList();
      }
    }
  }
}
