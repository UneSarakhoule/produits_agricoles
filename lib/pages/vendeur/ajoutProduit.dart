import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Ajout du package

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
  File? _imageFile;
  double _rating = 3.0;
  List<String> _categories = []; // Liste pour stocker les catégories

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Récupérer les catégories au démarrage de l'écran
  }

  // Fonction pour récupérer les catégories depuis Firestore
  Future<void> _fetchCategories() async {
    try {
      CollectionReference categoriesRef = FirebaseFirestore.instance.collection('Category');
      QuerySnapshot querySnapshot = await categoriesRef.get();

      setState(() {
        _categories = querySnapshot.docs.map((doc) => doc['nomCategory'] as String).toList();
      });
    } catch (e) {
      print('Erreur lors de la récupération des catégories: $e');
    }
  }

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
      User? user = FirebaseAuth.instance.currentUser;
      String userId = user?.uid ?? "ID inconnu";
      String produitId = FirebaseFirestore.instance.collection('Produits').doc().id;

      String imageUrl = '';

      // Vérification et upload de l'image
      if (_imageFile != null) {
        try {
          FirebaseStorage storage = FirebaseStorage.instance;
          Reference ref = storage.ref().child('produits/$produitId.jpg');
          UploadTask uploadTask = ref.putFile(_imageFile!);
          TaskSnapshot snapshot = await uploadTask;

          // Récupération de l'URL de l'image
          imageUrl = await snapshot.ref.getDownloadURL();
        } catch (e) {
          print("Erreur lors de l'upload de l'image : $e");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'enregistrement de l\'image')));
          return;
        }
      } else {
        // Gestion du cas où aucune image n'est sélectionnée
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez sélectionner une image')));
        return;
      }

      // Enregistrement du produit dans Firestore avec l'URL de l'image
      CollectionReference produits = FirebaseFirestore.instance.collection('Produits');
      return produits.doc(produitId).set({
        'nomProduit': _nameController.text,
        'description': _descriptionController.text,
        'prix': _priceController.text,
        'stock': _stockController.text,
        'photos': imageUrl,  // URL de l'image stockée
        'categories': _selectedCategory,
        'dateAjout': FieldValue.serverTimestamp(),
        'produitId': produitId,
        'userId': userId,
        'etoiles': _rating,
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
                  ? Image.file(_imageFile!)
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
              // DropdownButtonFormField pour les catégories
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((String category) {
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
              // SizedBox(height: 20),
              // RatingBar.builder(
              //   initialRating: 3.0,
              //   minRating: 1,
              //   direction: Axis.horizontal,
              //   allowHalfRating: true,
              //   itemCount: 5,
              //   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              //   itemBuilder: (context, _) => Icon(
              //     Icons.star,
              //     color: Colors.amber,
              //   ),
              //   onRatingUpdate: (rating) {
              //     setState(() {
              //       _rating = rating;
              //     });
              //   },
              // ),
              SizedBox(height: 40),
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
