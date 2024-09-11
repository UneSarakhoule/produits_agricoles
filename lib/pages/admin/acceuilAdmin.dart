import 'package:agricol/diagramme/adminDiagram.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Package pour Firebase Firestore
import 'package:flutter/material.dart';
import 'package:agricol/models/constants.dart';


class AcceuilAdmin extends StatefulWidget {
  const AcceuilAdmin({super.key});

  @override
  State<StatefulWidget> createState() => _AcceuilAdminState();
}

class _AcceuilAdminState extends State<AcceuilAdmin> {
  // Variables pour stocker les données récupérées de Firestore
  int totalUsers = 0;
  int totalProducts = 0;
  int totalOrders = 0;

  // Fonction pour récupérer les statistiques depuis Firestore
  void _fetchStats() async {
    // Collection des utilisateurs
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    // Collection des produits
    QuerySnapshot productsSnapshot = await FirebaseFirestore.instance.collection('Produits').get();
    // Collection des commandes (par exemple, si vous avez une collection 'orders')
    QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance.collection('commandes').get();

    // Mettre à jour l'état avec les nouvelles données
    setState(() {
      totalUsers = usersSnapshot.size;
      totalProducts = productsSnapshot.size;
      totalOrders = ordersSnapshot.size;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchStats(); // Récupérer les statistiques au démarrage
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: myConstants.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'STATISTIQUES GÉNÉRALES',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Affichage des cartes avec les statistiques
              SizedBox(
                height: 150, // Hauteur des cartes de statistiques
                child: ListView(
                  scrollDirection: Axis.horizontal, // Défilement horizontal
                  children: [
                    _buildStatCard('Total Utilisateurs', totalUsers.toString(), Icons.people),
                    _buildStatCard('Total Produits', totalProducts.toString(), Icons.shopping_bag),
                    _buildStatCard('Total Commandes', totalOrders.toString(), Icons.shopping_cart),
                  ],
                ),
              ),


              const SizedBox(height: 30),

              // Section pour gérer les produits ou utilisateurs
              const Text(
                'Gérer les Données',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Boutons de gestion des utilisateurs et produits
              Admindiagram(),
            ],
          ),
        )

      ),
    );
  }

  // Méthode pour créer les cartes de statistiques
  Widget _buildStatCard(String title, String value, IconData icon) {
    Constants myConstants = Constants();
    return Card(
      color: myConstants.thirtyColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: myConstants.primaryColor),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
