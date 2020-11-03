import 'package:flutter/material.dart';
import 'package:medical/widgets/register_patient.dart';
import 'package:medical/widgets/register_doctor.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  List tabs = <Tab>[
    Tab(
      child: Text(
        'Doctor',
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    ),
    Tab(
      child: Text(
        'Patient',
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xffEE2980),
          centerTitle: true,
          title: Text(
            "Register",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          bottom: TabBar(
              labelStyle: TextStyle(fontSize: 12),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.red,
              indicatorColor: Colors.white,
              tabs: tabs),
        ),
        body: TabBarView(
          children: <Widget>[
            RegisterDoctor(),
            RegisterPatient(),
          ],
        ),
      ),
    );
  }
}
