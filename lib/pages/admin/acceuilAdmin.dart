import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AcceuilAdmin extends StatefulWidget {
  const AcceuilAdmin({super.key});

  @override
  State<StatefulWidget> createState() => _Acceuil();
}

class _Acceuil extends State<AcceuilAdmin> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, int> categoryCounts = {};

  @override
  void initState() {
    super.initState();
    fetchCategoryCounts();
  }

  Future<void> fetchCategoryCounts() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      final Map<String, int> counts = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final category = data['type'] as String; // Remplacez 'category' par le champ approprié

        if (counts.containsKey(category)) {
          counts[category] = counts[category]! + 1;
        } else {
          counts[category] = 1;
        }
      }

      setState(() {
        categoryCounts = counts;
      });
    } catch (e) {
      print('Failed to load categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Category Distribution')),
      body: categoryCounts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 40,
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final category = categoryCounts.keys.elementAt(value.toInt());
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(category),
                          );
                        },
                      )
                  ),
                  leftTitles :AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  //leftTitles: SideTitles(showTitles: true),
                ),
            borderData: FlBorderData(show: true),
            barGroups: categoryCounts.entries.map((entry) {
              return BarChartGroupData(
                x: categoryCounts.keys.toList().indexOf(entry.key),
                barRods: [
                  BarChartRodData(
                    toY: entry.value.toDouble(),
                    color: Colors.blue,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
