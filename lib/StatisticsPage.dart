import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> _fetchDoctorRatings() async {
    Map<String, int> doctorRatings = {};

    try {
      QuerySnapshot evaluationSnapshot = await _firestore.collection('evaluations').get();

      for (var doc in evaluationSnapshot.docs) {
        String doctorId = doc['medecinId'];
        int rating = doc['rating'];

        if (doctorRatings.containsKey(doctorId)) {
          doctorRatings[doctorId] = doctorRatings[doctorId]! + rating;
        } else {
          doctorRatings[doctorId] = rating;
        }
      }
    } catch (e) {
      print('Error fetching evaluations: $e');
    }

    return doctorRatings;
  }

  Future<String> _fetchDoctorName(String doctorId) async {
    try {
      DocumentSnapshot doctorSnapshot = await _firestore
          .collection('prestataire_service')
          .doc('Medecin')
          .collection('Medecin')
          .doc(doctorId)
          .get();

      if (doctorSnapshot.exists) {
        var doctorDoc = doctorSnapshot.data() as Map<String, dynamic>;
        return '${doctorDoc['prenom']} ${doctorDoc['nom']}';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print('Error fetching doctor name: $e');
      return 'Unknown';
    }
  }

  Future<List<Map<String, dynamic>>> _fetchDoctorsWithRatings() async {
    List<Map<String, dynamic>> doctorsWithRatings = [];
    Map<String, int> doctorRatings = await _fetchDoctorRatings();

    for (var doctorId in doctorRatings.keys) {
      String doctorName = await _fetchDoctorName(doctorId);
      doctorsWithRatings.add({
        'doctorName': doctorName,
        'totalStars': doctorRatings[doctorId],
      });
    }

    // Trier par nombre d'étoiles décroissant et ne garder que les 4 premiers
    doctorsWithRatings.sort((a, b) => b['totalStars'].compareTo(a['totalStars']));
    if (doctorsWithRatings.length > 4) {
      doctorsWithRatings = doctorsWithRatings.sublist(0, 4);
    }

    return doctorsWithRatings;
  }

  Widget getTitles(double value, TitleMeta meta, List<Map<String, dynamic>> doctorRatings) {
    final style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 10, // Réduction de la taille du texte pour une meilleure lisibilité
    );
    final doctorName = doctorRatings[value.toInt()]['doctorName'].split(' ');
    final formattedDoctorName = doctorName.join('\n'); // Affichage du nom en vertical
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: Text(formattedDoctorName, style: style, textAlign: TextAlign.center),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Ratings Statistics'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchDoctorsWithRatings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No ratings data found'));
          } else {
            var doctorRatings = snapshot.data!;
            var totalRatings = doctorRatings.fold<int>(0, (sum, item) => sum + item['totalStars'] as int);
            var averageRating = totalRatings / doctorRatings.length;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Average Rating: ${averageRating.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Top 4 Doctors by Ratings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: doctorRatings.map((e) => e['totalStars'] as int).reduce((a, b) => a > b ? a : b).toDouble() + 5,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) => getTitles(value, meta, doctorRatings),
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: doctorRatings.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> doctorData = entry.value;

                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: doctorData['totalStars'].toDouble(),
                                color: Colors.lightBlueAccent,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
