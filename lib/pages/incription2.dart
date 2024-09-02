import 'package:agricol/repository/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agricol/models/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../models/myTextField.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<StatefulWidget> createState() => _Inscription();
}

class _Inscription extends State<Inscription> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? nomErrorMsg;
  String? prenomErrorMsg;
  String? emailErrorMsg;
  String? passwordErrorMsg;
  String? globalErrorMsg;
  String? selectedType = 'CLIENT';
  bool _obscurePassword = true;
  bool inscriptionRequired = false;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: screenHeight,
                  decoration: BoxDecoration(color: myConstants.primaryColor),
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.75,
                      // constraints: BoxConstraints(
                      //   maxHeight: screenHeight * 0.75,
                      // ),
                      decoration: ShapeDecoration(
                        color: myConstants.UnBlanc,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: myConstants.secondaryColor),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.07,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: screenHeight * 0.07),
                            _buildInputField(
                              label: 'Nom',
                              icon: Icons.person,
                              controller: _nomController,
                              errorMsg: nomErrorMsg,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            _buildInputField(
                              label: 'Prenom',
                              icon: Icons.person,
                              controller: _prenomController,
                              errorMsg: prenomErrorMsg,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            _buildInputField(
                              label: 'Email',
                              icon: Icons.email,
                              controller: _emailController,
                              errorMsg: emailErrorMsg,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            _buildInputField(
                              label: 'Mot de passe',
                              icon: Icons.lock,
                              controller: _passwordController,
                              errorMsg: passwordErrorMsg,
                              obscureText: _obscurePassword,
                              toggleObscureText: _toggleObscurePassword,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            _buildDropdown(myConstants),
                            SizedBox(height: screenHeight * 0.03),
                            _buildButton(myConstants),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.14,
                  top: screenHeight * 0.20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/connexion');
                    },
                    child: Text(
                      '< Retour',
                      style: TextStyle(
                        color: myConstants.blackColor,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenHeight * 0.75,
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Transform.rotate(
                      angle: 3.14159,
                      child: _buildArc(),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.14,
                  left: screenWidth * 0.47,
                  right: screenWidth * 0.1,
                  child: Column(
                    children: [
                      Text(
                        "S'inscrire",
                        style: TextStyle(
                          color: myConstants.primaryColor,
                          fontSize: screenWidth * 0.07,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.00),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    String? errorMsg,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    void Function()? toggleObscureText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            MyTextField(
              controller: controller,
              hintText: label,
              obscureText: obscureText,
              keyboardType: keyboardType,
              prefixIcon: Icon(icon, color: Constants().color7, size: 18),
            ),
            if (label == 'Mot de passe')
              Positioned(
                right: 10,
                top: -5,
                child: IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Constants().color7,
                  ),
                  onPressed: toggleObscureText,
                ),
              ),
          ],
        ),
        if (errorMsg != null)
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Text(
              errorMsg,
              style: TextStyle(
                color: Constants().red,
                fontSize: 10,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDropdown(Constants myConstants) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: ShapeDecoration(
        color: myConstants.color9,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedType,
        decoration: InputDecoration(
          filled: true,
          fillColor: myConstants.color9,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        ),
        items: [
          DropdownMenuItem(
            value: 'CLIENT',
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: myConstants.color7,
                  size: 18,
                ),
                const SizedBox(width: 13),
                Text(
                  'ACHETEUR',
                  style: TextStyle(fontSize: 13, color: myConstants.color7),
                ),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'VENDEUR',
            child: Row(
              children: [
                Icon(
                  Icons.store,
                  color: myConstants.color7,
                  size: 18,
                ),
                const SizedBox(width: 13),
                Text(
                  'VENDEUR',
                  style: TextStyle(fontSize: 13, color: myConstants.color7),
                ),
              ],
            ),
          ),
          // DropdownMenuItem(
          //   value: 'LES DEUX',
          //   child: Row(
          //     children: [
          //       Icon(
          //         Icons.people,
          //         color: myConstants.color7,
          //         size: 18,
          //       ),
          //       const SizedBox(width: 13),
          //       Text(
          //         'LES DEUX',
          //         style: TextStyle(fontSize: 13, color: myConstants.color7),
          //       ),
          //     ],
          //   ),
          // ),
        ],
        onChanged: (value) {
          setState(() {
            selectedType = value;
          });
        },
        icon: Icon(
          Icons.arrow_drop_down,
          color: myConstants.color7,
        ),
      ),
    );
  }

  Widget _buildButton(Constants myConstants) {
    return GestureDetector(
      onTap:_inscription,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: myConstants.primaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            "S'inscrire",
            style: TextStyle(
              color: myConstants.UnBlanc,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArc() {
    return Image.asset(
      'assets/images/arc2.png',
      width: 301,
      fit: BoxFit.cover,
    );
  }

  void _inscription() async {
    String nom = _nomController.text;
    String prenom = _prenomController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    // Réinitialisez les messages d'erreur
    setState(() {
      nomErrorMsg = null;
      prenomErrorMsg = null;
      emailErrorMsg = null;
      passwordErrorMsg = null;
      globalErrorMsg = null;
    });

    // Validation des champs
    if (nom.isEmpty) {
      setState(() => nomErrorMsg = 'Champ requis');
    }
    if (prenom.isEmpty) {
      setState(() => prenomErrorMsg = 'Champ requis');
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() => emailErrorMsg = 'Email non valide');
    }
    if (password.isEmpty) {
      setState(() => passwordErrorMsg = 'Champ requis');
    } else if (password.length < 6) {
      setState(() => passwordErrorMsg = 'Le mot de passe doit contenir au moins 6 caractères');
    }

    // Si des erreurs sont présentes, arrêtez-vous ici
    if (nomErrorMsg != null || prenomErrorMsg != null || emailErrorMsg != null
        || passwordErrorMsg != null) {
      return;
    }

    // Tentative d'inscription
    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);
      if (user != null) {
        print("L'inscription est un succès");

        // Ajouter l'utilisateur à Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'type': selectedType,
          'photoURL': 'assets/images/userLogo.png',
        });

        // Redirigez vers la page de connexion
        Navigator.pushNamed(context, "/connexion");
      } else {
        print("Erreur lors de l'inscription");
      }
    } catch (e) {
      print("Erreur : $e");
    }
  }






}
