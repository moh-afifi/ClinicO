import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical/screens/patient/edit_patient_reserv.dart';

class PatientReservCard extends StatefulWidget {
  PatientReservCard({this.hour, this.minute, this.amPm, this.doctorName});
  final String hour, minute, amPm, doctorName;
  @override
  _PatientReservCardState createState() => _PatientReservCardState();
}

class _PatientReservCardState extends State<PatientReservCard> {
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String docId;
  getPatientInfo() async {
    await for (var snapshot
        in _fireStore.collection('PatientAppointments').snapshots()) {
      for (var message in snapshot.documents) {
        if (loggedInUser.email == message.data['patientId']) {
          docId = message.data['docId'];
        }
      }
    }
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    getPatientInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Doctor:',
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  widget.doctorName,
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0xffEE2980),
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 40,
                    ),
                    onPressed: () async {
                      await _fireStore
                          .collection('PatientAppointments')
                          .document(docId)
                          .delete();
                    }),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              color: Colors.black,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'H: ${widget.hour}',
                      style: TextStyle(fontSize: 25),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.teal,
                          size: 40,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPatientReserv(
                                label: 'hour',
                                docId: docId,
                              ),
                            ),
                          );
                        }),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 1,
                  height: 100,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'M: ${widget.minute}',
                      style: TextStyle(fontSize: 25),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.teal,
                          size: 40,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPatientReserv(
                                label: 'minute',
                                docId: docId,
                              ),
                            ),
                          );
                        }),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 1,
                  height: 100,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'amPm: ${widget.amPm}',
                      style: TextStyle(fontSize: 25),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.teal,
                          size: 40,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPatientReserv(
                                label: 'amPm',
                                docId: docId,
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
