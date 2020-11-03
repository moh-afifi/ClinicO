import 'package:flutter/material.dart';
import 'package:medical/screens/doctor/patient_profile.dart';
import 'package:medical/screens/doctor/choose_disease_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReusablePatientCard extends StatefulWidget {
  ReusablePatientCard({this.patientId});
  final String patientId;
  @override
  _ReusablePatientCardState createState() => _ReusablePatientCardState();
}

class _ReusablePatientCardState extends State<ReusablePatientCard> {
  final _fireStore = Firestore.instance;
  String patientName;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChooseDisease(
              patientId: widget.patientId,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Card(
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: _fireStore.collection('patientInfo').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blueAccent,
                    ),
                  );
                }

                final items = snapshot.data.documents;

                for (var item in items) {
                  if (widget.patientId == (item.data['id']).toString().substring(6)) {
                    patientName = item.data['name'];
                  }
                }
                return Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xffEE2980),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      patientName,
                      style: TextStyle(fontSize: 13, color: Colors.deepPurple),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
