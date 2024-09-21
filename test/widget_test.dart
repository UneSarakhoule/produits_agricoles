import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agricol/main.dart';
import 'package:agricol/pages/slide1.dart';
import 'package:agricol/pages/slide3.dart';

void main() {
  testWidgets('Test si Slide1 s\'affiche correctement', (WidgetTester tester) async {
    // Construire notre application et déclencher un frame.
    await tester.pumpWidget(const MyApp());

    // Simuler le passage du temps pour que la Timer soit terminée
    await tester.pump(const Duration(milliseconds: 1000)); // Simule 1 seconde

    // Vérifier que Slide1 est bien affiché
    expect(find.byType(Slide1), findsOneWidget);

    // // Simuler le passage du temps pour que l'animation soit terminée
    // await tester.pumpAndSettle();
    //
    // // Vérifier que Slide3 est bien affiché après la navigation
    // expect(find.byType(Slide3), findsOneWidget);
    //
    // // Vérifier que l'image du logo est présente
    // expect(find.byType(Image), findsOneWidget);

    // // Vérifier que le Slide1 a la couleur de fond correcte
    // final slide1Container = tester.widget<Container>(find.byType(Container).first);
    // expect(slide1Container.color, equals(Colors.brown)); // Remplacez par la couleur attendue
  });
}
