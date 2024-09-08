import 'package:cloud_firestore/cloud_firestore.dart';

// class Cart {
//   final List<CartItem> _items = [];
//
//   List<CartItem> get items => _items;
//
//   void addItem(QueryDocumentSnapshot produit, int quantity) {
//     var existingItem = _items.firstWhere(
//           (item) => item.produit.id == produit.id,
//       orElse: () => CartItem(produit, 0),
//     );
//
//     if (existingItem.quantity == 0) {
//       _items.add(CartItem(produit, quantity));
//     } else {
//       existingItem.quantity += quantity;
//     }
//   }
//
//   void clear() {
//     items.clear();
//   }
// }
//
// class CartItem {
//   final QueryDocumentSnapshot produit;
//   int quantity;
//
//   CartItem(this.produit, this.quantity);
// }

class CartItem {
  final Map<String, dynamic> produit;
  final int quantity;

  CartItem({required this.produit, required this.quantity});
}

class Cart {
  List<CartItem> items = [];
}


final Cart cart = Cart();
