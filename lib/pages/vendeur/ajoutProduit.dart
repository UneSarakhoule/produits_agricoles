import 'package:agricol/models/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../../models/constants.dart';

class AjoutProduit extends StatefulWidget {
  const AjoutProduit({super.key});

  @override
  State<AjoutProduit> createState() => _AjoutProduitState();
}

class _AjoutProduitState extends State<AjoutProduit> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  String? _selectedCategory;
  File? _imageFile; // Variable pour stocker l'image sélectionnée

  // Fonction pour sélectionner une image depuis la galerie ou la caméra
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _ajouterProduit() async {
    if (_formKey.currentState!.validate()) {
      // Récupérer l'ID de l'utilisateur connecté
      User? user = FirebaseAuth.instance.currentUser;
      String userId = user?.uid ?? "ID inconnu";

      // Générer un ID unique pour le produit
      String produitId = FirebaseFirestore.instance.collection('Produits').doc().id;

      // URL de l'image à stocker
      String imageUrl = '';

      if (_imageFile != null) {
        try {
          // Stocker l'image dans Firebase Storage
          FirebaseStorage storage = FirebaseStorage.instance;
          Reference ref = storage.ref().child('produits/$produitId.jpg');
          UploadTask uploadTask = ref.putFile(_imageFile!);

          // Attendre que l'upload soit terminé
          TaskSnapshot snapshot = await uploadTask;

          // Obtenir l'URL de l'image
          imageUrl = await snapshot.ref.getDownloadURL();
        } catch (e) {
          print("Erreur lors de l'upload de l'image : $e");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'upload de l\'image')));
          return;
        }

      }

      // Enregistrer les données dans Firestore
      CollectionReference produits = FirebaseFirestore.instance.collection('Produits');
      return produits.doc(produitId).set({
        'nomProduit': _nameController.text,
        'description': _descriptionController.text,
        'prix': _priceController.text,
        'stock': _stockController.text,
        'photos': imageUrl, // URL de l'image dans Firebase Storage
        'categories': _selectedCategory,
        'dateAjout': FieldValue.serverTimestamp(),
        'produitId': produitId, // ID généré automatiquement
        'userId': userId, // ID de l'utilisateur connecté
        'etoiles': 1, // un champs etoiles pour permettre au client de noter
      }).then((value) {
        print("Produit ajouté avec succès");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Produit ajouté avec succès')));
      }).catchError((error) {
        print("Erreur lors de l'ajout du produit : $error");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout du produit')));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un produit"),
      ),
      drawer: DrawerVendeur(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom du produit',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom du produit';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Prix',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le prix';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le stock';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              _imageFile != null
                  ? Image.file(_imageFile!) // Afficher l'image sélectionnée
                  : Text("Aucune image sélectionnée"),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: Icon(Icons.camera),
                label: Text('Prendre une photo'),
              ),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: Icon(Icons.photo_library),
                label: Text('Choisir depuis la galerie'),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
                items: ['Fruits', 'Légumes', 'Epices'].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une catégorie';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _ajouterProduit,
                child: Text('Ajouter le produit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
