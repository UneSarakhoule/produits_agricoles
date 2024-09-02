import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';

class Drawerclient extends StatelessWidget {
  const Drawerclient({super.key});

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
                      key: UniqueKey(),
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
                leading: Icon(Icons.location_on_sharp),
                title: Text('Votre adresse'),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.money),
                title: Text('Mode de paiement'),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.history_edu_sharp),
                title: Text('Historique des commandes'),
                onTap: () {
                  Navigator.pushNamed(context, '/historiqueCommandes');
                },
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.book),
                title: Text('Condition d\'utilisation'),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.question_answer_outlined),
                title: Text('Contactez-nous'),
              ),
              SizedBox(height: 30),
              ListTile(
                leading: Icon(Icons.settings_power),
                title: Text(
                  'Déconnexion',
                  style: TextStyle(color: myConstants.blackColor.withOpacity(0.5)),
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
