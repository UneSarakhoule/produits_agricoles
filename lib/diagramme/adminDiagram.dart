import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:agricol/models/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Admindiagram extends StatefulWidget {
  const Admindiagram({super.key});

  @override
  State<Admindiagram> createState() => _AdmindiagramState();
}

class _AdmindiagramState extends State<Admindiagram> {
  List<Map<String, dynamic>> monthlyData = [];

  Constants myConstants = Constants();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    final userDocs = querySnapshot.docs;

    // Process data to count users by month
    Map<String, int> monthCounts = {};

    for (var doc in userDocs) {
      final dateInscrit = doc['dateInscrit'] as Timestamp;
      final date = dateInscrit.toDate();
      final monthYear = '${date.month}/${date.year}';

      if (monthCounts.containsKey(monthYear)) {
        monthCounts[monthYear] = monthCounts[monthYear]! + 1;
      } else {
        monthCounts[monthYear] = 1;
      }
    }

    // Convert the map to a list of data for the chart
    setState(() {
      monthlyData = monthCounts.entries.map((entry) {
        final monthIndex = int.parse(entry.key.split('/')[0]) - 1; // January is 0
        return {'month': monthIndex, 'count': entry.value};
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscriptions Mensuelles'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BarChart(mainBarData()),
      ),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            getTitlesWidget: getBottomTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: getLeftTitles,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: myConstants.gris3,
          width: 1,
        ),
      ),
      barGroups: getBarGroups(),
      alignment: BarChartAlignment.spaceAround,
    );
  }

  List<BarChartGroupData> getBarGroups() {
    // Assurez-vous que les mois sont dans l'ordre
    final sortedData = List.generate(12, (index) =>
        monthlyData.firstWhere((entry) => entry['month'] == index, orElse: () => {'month': index, 'count': 0})
    );

    return sortedData.map((entry) {
      return BarChartGroupData(
        x: entry['month'],
        barRods: [
          BarChartRodData(
            toY: entry['count'].toDouble(),
            color: myConstants.bleu,
            width: 15,
            borderRadius: BorderRadius.zero,
          ),
        ],
      );
    }).toList();
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Jan', style: style);
        break;
      case 1:
        text = const Text('Feb', style: style);
        break;
      case 2:
        text = const Text('Mar', style: style);
        break;
      case 3:
        text = const Text('Apr', style: style);
        break;
      case 4:
        text = const Text('May', style: style);
        break;
      case 5:
        text = const Text('Jun', style: style);
        break;
      case 6:
        text = const Text('Jul', style: style);
        break;
      case 7:
        text = const Text('Aug', style: style);
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
        text = const Text('Dec', style: style);
        break;
      default:
        text = const Text('', style: style);
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        value.toInt().toString(),
        style: TextStyle(
          color: myConstants.gris,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

