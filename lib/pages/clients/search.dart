import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/constants.dart';
import '../../models/product.dart'; // Importer ou créer le modèle de produit
import 'package:agricol/pages/clients/DetailsProduit.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _allProducts = []; // Liste de tous les produits
  List<QueryDocumentSnapshot> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Récupérer les produits depuis Firestore
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Récupérer les produits de Firestore
  Future<void> _fetchProducts() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Produits').get();
      setState(() {
        _allProducts = snapshot.docs;
        _filteredProducts = _allProducts;
      });
    } catch (e) {
      print('Erreur lors de la récupération des produits : $e');
    }
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((doc) {
        return (doc['nomProduit'] as String).toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: myConstants.secondaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(''),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/bottomNavigation');
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 90,),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_sharp),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterProducts();
                          },
                        )
                        : null,
                    hintText: 'Rechercher ...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _filteredProducts.isEmpty
                      ? Center(child: Text('Aucun produit trouvé.'))
                      : ListView.builder(
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final doc = _filteredProducts[index];
                          return ListTile(
                            title: Text(doc['nomProduit']),
                            subtitle: Text('${doc['prix']} FCFA'),
                            leading: Image.network(doc['photos']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetails(produit: doc),
                                ),
                              );
                            },
                          );
                        },
                      ),
                ),
              ],
            ),
            // Positioned(
            //   left: 22,
            //   top: 288,
            //   child: Container(
            //     width: screenWidth * 0.8,
            //     height: screenHeight * 0.4,
            //     decoration: const BoxDecoration(
            //       image: DecorationImage(
            //         image: AssetImage('assets/images/search.jpg'),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
