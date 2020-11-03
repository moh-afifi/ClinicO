import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical/widgets/med_history_card.dart';

class MedHistoryDoctor extends StatefulWidget {
  MedHistoryDoctor({this.doctorId});
  final String doctorId;
  @override
  _MedHistoryDoctorState createState() => _MedHistoryDoctorState();
}

class _MedHistoryDoctorState extends State<MedHistoryDoctor> {
  final _fireStore = Firestore.instance;
  String name,
      medicine,
      disease,
      age,
      pulse,
      pressure,
      temp,
      hour,
      minute,
      amPm,
      date;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffEE2980),
        title: Text(
          'Medical History',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: _fireStore.collection('chronic').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueAccent,
                  ),
                );
              }

              final items = snapshot.data.documents.reversed;

              List<HistoryCard> itemElements = [];

              for (var item in items) {
                if (widget.doctorId == item.data['doctorId']) {
                  name = item.data['name'];
                  age = item.data['age'];
                  medicine = item.data['medicine'];
                  disease = item.data['disease'];
                  date = item.data['date'];
                  hour = item.data['hour'];
                  minute = item.data['minute'];
                  amPm = item.data['amPm'];
                  pulse = (item.data['pulse']).toString();
                  pressure = item.data['pressure'];
                  temp = item.data['temp'];

                  final reusableCard = HistoryCard(
                    name: name,
                    temp: temp,
                    pulse: pulse,
                    pressure: pressure,
                    amPm: amPm,
                    minute: minute,
                    hour: hour,
                    date: date,
                    age: age,
                    disease: disease,
                    medicine: medicine,
                  );
                  itemElements.add(reusableCard);
                }
              }
              return Column(
                //padding: EdgeInsets.all(15),
                children: itemElements,
              );
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _fireStore.collection('nonChronic').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueAccent,
                  ),
                );
              }

              final items = snapshot.data.documents.reversed;

              List<HistoryCard> itemElements = [];

              for (var item in items) {
                if (widget.doctorId == item.data['doctorId']) {
                  name = item.data['name'];
                  age = item.data['age'];
                  medicine = item.data['medicine'];
                  disease = item.data['disease'];
                  date = item.data['date'];
                  hour = item.data['hour'];
                  minute = item.data['minute'];
                  amPm = item.data['amPm'];
                  pulse = (item.data['pulse']).toString();
                  pressure = item.data['pressure'];
                  temp = item.data['temp'];

                  final reusableCard = HistoryCard(
                    name: name,
                    temp: temp,
                    pulse: pulse,
                    pressure: pressure,
                    amPm: amPm,
                    minute: minute,
                    hour: hour,
                    date: date,
                    age: age,
                    disease: disease,
                    medicine: medicine,
                  );
                  itemElements.add(reusableCard);
                }
              }
              return Column(
                // padding: EdgeInsets.all(15),
                children: itemElements,
              );
            },
          ),
        ],
      ),
    );
  }
}
