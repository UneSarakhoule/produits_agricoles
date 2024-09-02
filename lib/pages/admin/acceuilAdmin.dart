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
  List<FlSpot> stats = [];

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      final List<FlSpot> loadedStats = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Check if 'x' and 'y' are present and convert them to double
        final x = data['x']?.toDouble() ?? 0.0;
        final y = data['y']?.toDouble() ?? 0.0;
        return FlSpot(x, y);
      }).toList();

      setState(() {
        stats = loadedStats;
      });
    } catch (e) {
      print('Failed to load stats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Usage Statistics')),
      body: stats.isEmpty
          ? Center(child: CircularProgressIndicator())
          : LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: stats,
            ),
          ],
        ),
      ),
    );
  }
}
