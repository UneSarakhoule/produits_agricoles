import 'package:agricol/menu/bottomNavigation.dart';
import 'package:agricol/pages/admin/acceuilAdmin.dart';
import 'package:agricol/pages/clients/AcceuilClient.dart';
import 'package:agricol/pages/clients/historiqueCommandes.dart';
import 'package:agricol/pages/connexion2.dart';
import 'package:agricol/pages/incription2.dart';
import 'package:agricol/pages/modifierUser.dart';
import 'package:agricol/pages/slide1.dart';
import 'package:agricol/pages/slide3.dart';
import 'package:agricol/pages/vendeur/acceuil.dart';
import 'package:agricol/pages/vendeur/ajoutProduit.dart';
import 'package:agricol/pages/vendeur/listeProduit.dart';
import 'package:agricol/pages/vendeur/modifierProduit.dart';
import 'package:agricol/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agricol/provider/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context)=>ThemeProvider()
        )
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child)
        {
          return MaterialApp(
            title: 'APPLICATION DE VENTE DE PRODUITS AGRICOLES',
            theme: Styles.themeData(isDarkTheme: themeProvider.getIsDarkTheme, context: context),
            initialRoute: '/',
            routes: {
              '/': (context) => const Slide1(),
              '/slide3': (context) =>const Slide3(),
              '/inscription': (context) =>const Inscription(), // Route pour la page d'inscription
              '/connexion': (context) =>const  Connexion2(), // Route pour la page de connexion
              '/acceuilVendeur': (context) =>const  AcceuilVendeur(), //Route pour la page d'acceuil du vendeur
              '/acceuilClient': (context) => const BottomNavigation(), // Route pour la page d'acceuil du client
              '/acceuilAdmin': (context) => const AcceuilAdmin(), // Route pour la page d'acceuil de l'admin
              '/bottomNavigation': (context) => const BottomNavigation(), // Route pour la page d'acceuil de l'admin
              '/ajoutProduit': (context) => const AjoutProduit(), // Route pour l'ajout d'un produit
              '/listeProduit': (context) => const Listeproduit(), // Route pour la liste des produits
              '/modifierUser': (context) => const Modifieruser(), // Route modifier l'utilisateur
              '/modifierProduit': (context) => Modifierproduit(product: ModalRoute.of(context)!.settings.arguments as DocumentSnapshot), // Route pour la modification d'un produit
              '/historiqueCommandes': (context) => const Historiquecommandes(),

            },
            debugShowCheckedModeBanner: false,
          );
        },

      ),
    );
  }
}
