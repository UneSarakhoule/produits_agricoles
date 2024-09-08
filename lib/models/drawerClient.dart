import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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

  Future<String> _getAddress() async {
    try {
      // Obtenez la position actuelle
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // Obtenez l'adresse à partir des coordonnées
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placemark = placemarks[0];

      // Formatez l'adresse
      String address = '${placemark.street ?? ''}, ${placemark.locality ?? ''}, ${placemark.postalCode ?? ''}, ${placemark.country ?? ''}';
      return address;
    } catch (e) {
      return 'Adresse non disponible';
    }
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
              FutureBuilder<String>(
                future: _getAddress(),
                builder: (context, addressSnapshot) {
                  if (addressSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      leading: Icon(Icons.location_on_sharp),
                      title: Text('Votre adresse'),
                      subtitle: Text('Chargement...'),
                    );
                  } else if (addressSnapshot.hasError) {
                    return ListTile(
                      leading: Icon(Icons.location_on_sharp),
                      title: Text('Votre adresse'),
                      subtitle: Text('Erreur : ${addressSnapshot.error}'),
                    );
                  } else {
                    return ListTile(
                      leading: Icon(Icons.location_on_sharp),
                      title: Text('Votre adresse'),
                      subtitle: Text(addressSnapshot.data ?? 'Adresse non disponible'),
                    );
                  }
                },
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
