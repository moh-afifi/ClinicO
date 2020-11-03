import 'package:flutter/material.dart';
import 'package:medical/screens/doctor/patient_profile.dart';
import 'package:medical/screens/doctor/non_chronic.dart';
class ChooseDisease extends StatelessWidget {
  ChooseDisease({this.patientId});
  final String patientId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose Type',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffEE2980),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientProfile(
                      patientId: patientId,
                    ),
                  ),
                );
              },
              child: Container(
                width: 300,
                height: 100,
                margin: EdgeInsets.all(15.0),
                padding: EdgeInsets.all(15.0),
                color: Color(0xffEE2980),
                child: Center(
                  child: Text(
                    'Chronic',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NonChronicPatientProfile(
                      patientId: patientId,
                    ),
                  ),
                );
              },
              child: Container(
                width: 300,
                height: 100,
                margin: EdgeInsets.all(15.0),
                padding: EdgeInsets.all(15.0),
                color: Color(0xffEE2980),
                child: Center(
                  child: Text(
                    'Non-Chronic',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
