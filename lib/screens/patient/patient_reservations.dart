import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical/widgets/patient_reserv_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientReservations extends StatefulWidget {
  @override
  _PatientReservationsState createState() => _PatientReservationsState();
}

class _PatientReservationsState extends State<PatientReservations> {
  final _fireStore = Firestore.instance;
  String doctorName, hour, minute, amPm, patientId;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print('${loggedInUser.email}-------------------');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffEE2980),
        title: Text(
          'Patient Reservations',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: _fireStore.collection('PatientAppointments').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueAccent,
                  ),
                );
              }

              final items = snapshot.data.documents.reversed;

              List<PatientReservCard> itemElements = [];

              for (var item in items) {
                if (loggedInUser.email == item.data['patientId']) {
                  doctorName = item.data['doctorName'];
                  hour = item.data['hour'];
                  minute = item.data['minute'];
                  amPm = item.data['amPm'];
                  final reusableCard = PatientReservCard(
                    doctorName: doctorName,
                    hour: hour,
                    minute: minute,
                    amPm: amPm,
                  );
                  itemElements.add(reusableCard);
                }
              }
              return Expanded(
                child: ListView(
                  padding: EdgeInsets.all(15),
                  children: itemElements,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
