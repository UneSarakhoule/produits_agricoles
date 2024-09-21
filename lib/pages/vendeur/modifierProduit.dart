import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Modifierproduit extends StatefulWidget {
  final DocumentSnapshot product;

  const Modifierproduit({super.key, required this.product});

  @override
  State<Modifierproduit> createState() => _ModifierproduitState();
}

class _ModifierproduitState extends State<Modifierproduit> {

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;

  @override
  void initState() {
    super.initState();

    // Initialiser les contrôleurs avec les données du produit
    _nameController = TextEditingController(text: widget.product['nomProduit']);
    _descriptionController = TextEditingController(text: widget.product['description']);
    _priceController = TextEditingController(text: widget.product['prix'].toString());
    _stockController = TextEditingController(text: widget.product['stock'].toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  // Met à jour les informations du produit dans Firestore
  Future<void> _updateProduct() async {
    try {
      await FirebaseFirestore.instance
          .collection('Produits')
          .doc(widget.product.id)
          .update({
        'nomProduit': _nameController.text,
        'description': _descriptionController.text,
        'prix': double.parse(_priceController.text),
        'stock': int.parse(_stockController.text),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit mis à jour avec succès')),
      );

      Navigator.pop(context); // Retourner à la page précédente après la mise à jour
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de mise à jour : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier Produit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom du Produit'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Prix'),
            ),
            TextField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stock'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProduct,
              child: const Text('Mettre à jour'),
            ),
          ],
        ),
      ),
    );
  }
}

