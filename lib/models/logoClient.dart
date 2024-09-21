import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({super.key});

  Future<Map<String, dynamic>> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        return {
          'photoUrl': userDoc['photoURL'] ?? null,
        };
      }
    }

    return {
      'photoUrl': null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: CircularProgressIndicator(),
            centerTitle: true,
          );
        }

        if (snapshot.hasError) {
          return AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('Erreur'), // Affiche un message d'erreur
            centerTitle: true,
          );
        }

        final userData = snapshot.data!;
        String? photoUrl = userData['photoUrl'];

        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 30,
              ),
              const SizedBox(width: 8),
              const Text(
                'AGRIINNOVATE',
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/modifierUser');
              },
              child: CircleAvatar(
                radius: 15,
                backgroundImage: photoUrl != null
                    ? NetworkImage(photoUrl)
                    : AssetImage('assets/images/userLogo.png') as ImageProvider,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
