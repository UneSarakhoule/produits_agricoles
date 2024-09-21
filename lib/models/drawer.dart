import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';

class DrawerVendeur extends StatelessWidget {
  const DrawerVendeur({super.key});


  Future<Map<String, dynamic>> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      return {
        'prenom': userDoc['prenom'] ?? 'Prenom inconnu',
        'email': user.email ?? 'Email inconnu',
        'photoUrl': userDoc['photoURL'] ?? 'pas de photo',
      };
    }

    return {
      'prenom': 'Prenom inconnu',
      'email': 'Email inconnu',
      'photoUrl': null,
    };
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    return Drawer(
      child: FutureBuilder<Map<String, dynamic>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des données'));
          }

          final userData = snapshot.data!;
          String prenom = userData['prenom'];
          String email = userData['email'];
          String? photoUrl = userData['photoUrl'];

          return ListView(
            padding: EdgeInsets.only(
              top: 24 + MediaQuery.of(context).padding.top,
              bottom: 24,
            ),
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: photoUrl != null
                          ? NetworkImage(photoUrl)
                          : AssetImage('assets/images/userLogo.png')
                      as ImageProvider,
                    ),
                    SizedBox(height: 16),
                    Text(
                      prenom,
                      style: TextStyle(fontSize: 28),
                    ),
                    Text(
                      email,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Acceuil'),
                onTap: () {
                  Navigator.pushNamed(context, '/acceuilVendeur');
                },
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.add_chart_sharp),
                title: Text('Ajouter un produit'),
                onTap: () {
                  Navigator.pushNamed(context, '/ajoutProduit');
                },
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.book),
                title: Text('Liste des Produits'),
                onTap: () {
                  Navigator.pushNamed(context, '/listeProduit');
                },
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.question_answer_outlined),
                title: Text('Contactez-nous'),
                onTap: () {
                  Navigator.pushNamed(context, '');
                },
              ),
              SizedBox(height: 80),
              ListTile(
                leading: Icon(Icons.settings_power),
                title: Text(
                  'Deconnexion',
                  style: TextStyle(
                      color: myConstants.blackColor.withOpacity(0.5)),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/connexion');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
