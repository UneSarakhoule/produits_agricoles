import 'package:flutter/material.dart';
import 'package:agricol/models/constants.dart';
import 'package:agricol/models/myTextField.dart';
import '../repository/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Connexion2 extends StatefulWidget {
  const Connexion2({super.key});

  @override
  State<StatefulWidget> createState() => _Connexion2();
}

class _Connexion2 extends State<Connexion2> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? emailErrorMsg;
  String? passwordErrorMsg;
  bool _obscurePassword = true; // État pour l'affichage du mot de passe

  @override
  void dispose() {
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
                      height: screenHeight * 0.6,
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
                            SizedBox(height: screenHeight * 0.1),
                            _buildTextField(
                              controller: _emailController,
                              hintText: 'Email',
                              obscureText: false,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email,
                              errorMsg: emailErrorMsg,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            _buildTextField(
                              controller: _passwordController,
                              hintText: 'Mot de passe',
                              obscureText: _obscurePassword,
                              keyboardType: TextInputType.text,
                              prefixIcon: Icons.key,
                              errorMsg: passwordErrorMsg,
                              toggleObscureText: _toggleObscurePassword, // Passer la méthode de bascule
                            ),
                            SizedBox(height: screenHeight * 0.08),
                            _buildButton(myConstants),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bouton retour
                Positioned(
                  left: screenWidth * 0.17,
                  top: screenHeight * 0.22,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/slide3');
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

                // Titre et sous-titre
                Positioned(
                  top: screenHeight * 0.27,
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.1,
                  child: Column(
                    children: [
                      Text(
                        'Se Connecter',
                        style: TextStyle(
                          color: myConstants.primaryColor,
                          fontSize: screenWidth * 0.07,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Les champs sont obligatoires',
                        style: TextStyle(
                          color: myConstants.color7,
                          fontSize: screenWidth * 0.02,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Position de l'arc
                Positioned(
                  bottom: screenHeight * 0.2,
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildArc(),
                  ),
                ),

                // Mot de passe oublié
                Positioned(
                  bottom: screenHeight * 0.26,
                  left: screenWidth * 0.4,
                  right: screenWidth * 0.1,
                  child: Column(
                    children: [
                      Text(
                        'Mot de Passe oublié ?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: myConstants.gris,
                          fontSize: screenWidth * 0.035,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.19),
                    ],
                  ),
                ),
                // Creer un compte
                Positioned(
                  bottom: screenHeight * 0.10,
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.1,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/inscription');
                        },
                        child: Text(
                          'Créer un Nouveau Compte',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: myConstants.gris,
                            fontSize: screenWidth * 0.035,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.19),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required TextInputType keyboardType,
    required IconData prefixIcon,
    String? errorMsg,
    void Function()? toggleObscureText, // Ajoutez cette ligne
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            MyTextField(
              controller: controller,
              hintText: hintText,
              obscureText: obscureText,
              keyboardType: keyboardType,
              prefixIcon: Icon(prefixIcon, color: Constants().color7, size: 18),
            ),
            if (hintText == 'Mot de passe')
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
            padding: const EdgeInsets.only(top: 7.0),
            child: Text(
              errorMsg,
              style: TextStyle(
                color: Constants().red,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildButton(Constants myConstants) {
    return GestureDetector(
      onTap: _connexion,
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: ShapeDecoration(
          color: myConstants.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            'Se connecter',
            style: TextStyle(
              color: myConstants.color8,
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 0,
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

  void _connexion() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Réinitialisez les messages d'erreur
    setState(() {
      emailErrorMsg = null;
      passwordErrorMsg = null;
    });

    // Validation des champs
    if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() => emailErrorMsg = 'Email non valide');
    }
    if (password.isEmpty) {
      setState(() => passwordErrorMsg = 'Champ requis');
    } else if (password.length < 6) {
      setState(() => passwordErrorMsg = 'Le mot de passe doit contenir au moins 6 caractères');
    } else if (email == '' && password == '') {
      // Gérer ce cas si nécessaire
    }

    // Si des erreurs sont présentes, arrêtez-vous ici
    if (emailErrorMsg != null || passwordErrorMsg != null) {
      return;
    }

    // Vérification pour l'utilisateur spécial
    if (email == 'sidibemariama@gmail.com' && password == 'passer') {
      // Rediriger vers une page spéciale ou gérer la connexion pour cet utilisateur
      Navigator.pushNamed(context, "/acceuilAdmin");
      return;
    }

    // Tentative de connexion Firebase
    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        // Obtenez le type d'utilisateur depuis Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        String userType = userDoc['type'] ?? '';

        if (userType == 'VENDEUR') {
          Navigator.pushNamed(context, "/acceuilVendeur");
        } else if (userType == 'CLIENT') {
          Navigator.pushNamed(context, "/acceuilClient");
        } else if (userType == 'LES DEUX') {
          Navigator.pushNamed(context, "/acceuilClient");
        } else {
          print("Type d'utilisateur inconnu");
        }
      } else {
        print("Erreur lors de la connexion");
      }
    } catch (e) {
      print("Erreur : $e");
    }
  }

}
