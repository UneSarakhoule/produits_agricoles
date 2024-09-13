// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'package:agricol/main.dart';
//
// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(const MyApp());
//
//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);
//
//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();
//
//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:agricol/main.dart';
// import 'package:agricol/pages/clients/settings.dart';
// import 'package:agricol/pages/connexion2.dart';
// import 'package:agricol/pages/vendeur/acceuil.dart';
//
// void main() {
//   // Test pour vérifier que la page de connexion s'affiche correctement
//   testWidgets('Test si le bouton de connexion fonctionne', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       const MaterialApp(
//         home: Connexion2(), // S'assurer que c'est la bonne page
//       ),
//     );
//
//     // Vérifier que le bouton de connexion est présent
//     expect(find.text('Se connecter'), findsOneWidget);
//
//     // Appuyer sur le bouton de connexion
//     await tester.tap(find.text('Se connecter'));
//     await tester.pump(); // Reconstituer les widgets pour voir les changements
//
//     // Vérifier que la méthode de connexion a été appelée
//     // (Vous devrez peut-être utiliser un mock pour tester ce comportement)
//   });
//
//
//   // Test de la navigation de la page de connexion vers la page d'acceuil vendeur
//   testWidgets('Test de la navigation vers la page d\'acceuil vendeur', (WidgetTester tester) async {
//     // Charger l'application avec MaterialApp pour avoir un Navigator
//     await tester.pumpWidget(
//       const MaterialApp(
//         home: Connexion2(), // Commencer à partir de la page de connexion
//       ),
//     );
//
//     // Trouver le bouton de connexion et effectuer un clic
//     await tester.tap(find.text('Connexion'));
//     await tester.pumpAndSettle(); // Attendre que l'animation de navigation se termine
//
//     // Charger la page d'accueil du vendeur après la connexion
//     await tester.pumpWidget(const MaterialApp(
//       home: AcceuilVendeur(),
//     ));
//
//     // Vérifier que la page d'accueil du vendeur s'affiche
//     expect(find.byType(AcceuilVendeur), findsOneWidget);
//   });
//
//   // Test pour vérifier l'affichage de la page des paramètres clients
//   testWidgets('Test si la page des paramètres clients s\'affiche correctement', (WidgetTester tester) async {
//     // Charger l'application avec un Navigator pour permettre la navigation
//     await tester.pumpWidget(
//       MaterialApp(
//         initialRoute: '/',
//         routes: {
//           '/': (context) => Connexion2(),
//           '/parametre': (context) => const SettingsClient(),
//         },
//       ),
//     );
//
//     // Simuler la navigation vers la page des paramètres
//     await tester.tap(find.text('Connexion')); // Simuler une connexion
//     await tester.pumpAndSettle();
//
//     // Naviguer vers les paramètres
//     await tester.tap(find.text('Paramètres')); // Ajouter un bouton Paramètres si nécessaire
//     await tester.pumpAndSettle();
//
//     // Vérifier que l'élément "Paramètres" est présent
//     expect(find.byType(SettingsClient), findsOneWidget);
//   });
// }

