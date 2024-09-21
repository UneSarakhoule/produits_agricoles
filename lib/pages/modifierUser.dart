import 'dart:io';

import 'package:flutter/material.dart';
import 'package:agricol/models/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Modifieruser extends StatefulWidget {
  const Modifieruser({super.key});

  @override
  State<Modifieruser> createState() => _ModifieruserState();
}

class _ModifieruserState extends State<Modifieruser> {

  String? _photoUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _photoUrl = userDoc['photoURL'];
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Upload the image to Firebase Storage
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String filePath = 'users/${user.uid}/profile.jpg';
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child(filePath)
            .putFile(File(image.path));

        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Update Firestore with the new image URL
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'photoUrl': downloadUrl});

        setState(() {
          _photoUrl = downloadUrl;
        });
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: screenHeight,
          decoration: BoxDecoration(color: myConstants.thirtyColor),
          child: Stack(
            children: [
              
              // Bouton retour
              Positioned(
                left: screenWidth * 0.08,
                top: screenHeight * 0.05,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/acceuilClient');
                  },
                  child: Icon(Icons.arrow_back),
                ),
              ),
              Positioned(
                top: screenHeight * 0.15,
                left: screenWidth * 0.3,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: _photoUrl != null
                          ? NetworkImage(_photoUrl!)
                          : AssetImage('assets/images/userLogo.png')
                      as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: myConstants.gris2,
                          child: Icon(
                            Icons.camera,
                            color: myConstants.blackColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
        
      ],
    );
  }
}

