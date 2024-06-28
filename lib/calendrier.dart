import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendrierPage extends StatefulWidget {
  final List<dynamic> joursTravail;
  final Map<String, dynamic> horaires;
  final String idPatient;
  final String idMedecin;

  CalendrierPage({
    required this.joursTravail,
    required this.horaires,
    required this.idPatient,
    required this.idMedecin,
  });

  @override
  _CalendrierPageState createState() => _CalendrierPageState();
}

class _CalendrierPageState extends State<CalendrierPage> {
  late DateTime selectedDate;
  String? selectedHour;
  List<String> heuresDisponibles = [];
  List<String> heuresIndisponibles = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: TableCalendar(
              firstDay: DateTime.utc(2022),
              lastDay: DateTime.utc(2025),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.month,
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(color: Colors.red),
              ),
              calendarStyle: CalendarStyle(),
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
                CalendarFormat.week: 'Week',
              },
              enabledDayPredicate: (day) =>
                  !day.isBefore(DateTime.now().subtract(Duration(days: 1))),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) {
                  final isWorkDay =
                      widget.joursTravail.contains(_getWeekday(date));
                  final horairesJour =
                      isWorkDay ? widget.horaires[_getWeekday(date)] : null;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                        _generateAvailableHours(
                            horairesJour?[0], horairesJour?[1]);
                        _fetchIndisponibleHours(selectedDate);
                        selectedHour = null;
                        _showHorairesDialog(context);
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isWorkDay ? Colors.blue : Colors.transparent,
                      ),
                      child: Text(date.day.toString()),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekday(DateTime date) {
    switch (date.weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "";
    }
  }

  void _generateAvailableHours(String? startHour, String? endHour) {
    heuresDisponibles.clear();
    if (startHour != null && endHour != null) {
      int start = int.parse(startHour.split(':')[0]);
      int end = int.parse(endHour.split(':')[0]);
      for (int i = start; i <= end; i++) {
        heuresDisponibles.add('${i.toString().padLeft(2, '0')}:00');
      }
    }
  }

  void _fetchIndisponibleHours(DateTime selectedDate) async {
    heuresIndisponibles.clear();
    try {
      final snapshot = await firestore
          .collection('rendez_vous')
          .where('jour', isEqualTo: selectedDate.toString().substring(0, 10)) // Adjust to match the date format in your database
          .get();
      final List<String> heures = [];
      snapshot.docs.forEach((doc) {
        heures.add(doc['heure']);
      });
      setState(() {
        heuresIndisponibles = heures;
      });
    } catch (e) {
      print('Erreur lors du chargement des heures indisponibles : $e');
    }
  }

  void _showHorairesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Choose a time for ${_getWeekday(selectedDate)}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: heuresDisponibles.length,
                itemBuilder: (BuildContext context, int index) {
                  final heure = heuresDisponibles[index];
                  final isHourSelected = heure == selectedHour;
                  final isHourIndisponible =
                      heuresIndisponibles.contains(heure);

                  return GestureDetector(
                    onTap: isHourIndisponible
                        ? null
                        : () {
                            setState(() {
                              selectedHour = heure;
                            });
                          },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: isHourSelected
                            ? Colors.blue
                            : (isHourIndisponible ? Colors.grey : Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        heure,
                        style: TextStyle(
                          color: isHourSelected
                              ? Colors.white
                              : (isHourIndisponible ? Colors.grey : Colors.black),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (selectedDate != null && selectedHour != null) {
                  _enregistrerRendezVous(selectedHour!);
                  Navigator.of(context).pop(); // Close the dialog after confirmation
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select a date and time.'),
                    ),
                  );
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _enregistrerRendezVous(String selectedHour) async {
    try {
      DocumentSnapshot medecinSnapshot = await firestore
          .collection('prestataire_service')
          .doc('Medecin')
          .collection('Medecin')
          .doc(widget.idMedecin)
          .get();

      if (medecinSnapshot.exists) {
        String idMedecin = medecinSnapshot.get('userId');
        await firestore.collection('rendez_vous').add({
          'jour': selectedDate.toString().substring(0, 10), // Adjust to match the date format in your database
          'heure': selectedHour,
          'id_patient': widget.idPatient,
          'id_medecin': idMedecin,
          'date_creation': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment successfully scheduled')),
        );
      } else {
        print('Document médecin non trouvé');
      }
    } catch (e) {
      print('Erreur lors de l\'enregistrement du rendez-vous : $e');
    }
  }
}
