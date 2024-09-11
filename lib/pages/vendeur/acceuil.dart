import 'package:agricol/models/drawer.dart';
import 'package:flutter/material.dart';
import 'package:agricol/models/constants.dart';
import 'package:fl_chart/fl_chart.dart'; // Ajoute le package pour le graphique
import '../../models/logo.dart';

class AcceuilVendeur extends StatefulWidget {
  const AcceuilVendeur({super.key});

  @override
  State<StatefulWidget> createState() => _AcceuilVendeur();
}

class _AcceuilVendeur extends State<AcceuilVendeur> {
  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Appbar(),
      drawer: DrawerVendeur(),
      backgroundColor: myConstants.thirtyColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'DASHBOARD',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20), // Espace entre DASHBOARD et la barre de recherche
                Expanded(
                  child: Container(
                    height: 43,
                    child: SearchBar(
                      leading: Row(
                        children: [
                          const Icon(Icons.search_sharp),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            height: 26.0,
                            width: 1.0,
                            color: myConstants.gris2,
                          ),
                        ],
                      ),
                      hintText: 'Rechercher ...',
                      backgroundColor: MaterialStatePropertyAll(myConstants.thirtyColor),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Cartes du tableau de bord
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDashboardCard('Vos ventes réalisées', '0', Icons.shopping_cart),
                _buildDashboardCard('Notes d\'évaluation', '1', Icons.star),
                _buildDashboardCard('Commandes en cours', '5', Icons.pending_actions),
              ],
            ),
            const SizedBox(height: 30),

            // Titre du graphique
            const Text(
              'Vos activités',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Graphique à barres des activités mensuelles
            Expanded(
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: _getBottomTitles,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: _getLeftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _getBarGroups(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour créer les cartes du dashboard
  Widget _buildDashboardCard(String title, String value, IconData icon) {
    Constants myConstants = Constants();
    return Card(
      color: myConstants.thirtyColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: myConstants.primaryColor),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Labels pour les mois (axe des X)
  Widget _getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Jan', style: style);
        break;
      case 1:
        text = const Text('Fév', style: style);
        break;
      case 2:
        text = const Text('Mar', style: style);
        break;
      case 3:
        text = const Text('Avr', style: style);
        break;
      case 4:
        text = const Text('Mai', style: style);
        break;
      case 5:
        text = const Text('Juin', style: style);
        break;
      case 6:
        text = const Text('Juil', style: style);
        break;
      case 7:
        text = const Text('Août', style: style);
        break;
      case 8:
        text = const Text('Sep', style: style);
        break;
      case 9:
        text = const Text('Oct', style: style);
        break;
      case 10:
        text = const Text('Nov', style: style);
        break;
      case 11:
        text = const Text('Déc', style: style);
        break;
      default:
        text = const Text('');
        break;
    }
    return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }

  // Labels pour les chiffres à gauche (axe des Y)
  Widget _getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    return SideTitleWidget(
      child: Text(value.toInt().toString(), style: style),
      axisSide: meta.axisSide,
    );
  }

  // Données pour le graphique
  List<BarChartGroupData> _getBarGroups() {
    return [
      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 30)]),
      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 50)]),
      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 80)]),
      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 90)]),
      BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 70)]),
      BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 60)]),
      BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 85)]),
      BarChartGroupData(x: 7, barRods: [BarChartRodData(toY: 65)]),
      BarChartGroupData(x: 8, barRods: [BarChartRodData(toY: 75)]),
      BarChartGroupData(x: 9, barRods: [BarChartRodData(toY: 45)]),
      BarChartGroupData(x: 10, barRods: [BarChartRodData(toY: 55)]),
      BarChartGroupData(x: 11, barRods: [BarChartRodData(toY: 40)]),
    ];
  }
}
