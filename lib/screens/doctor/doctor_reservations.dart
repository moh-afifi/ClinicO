import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical/reusables/reusable_patient_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical/screens/app_screens/login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class DoctorReservations extends StatefulWidget {
  @override
  _DoctorReservationsState createState() => _DoctorReservationsState();
}

class _DoctorReservationsState extends State<DoctorReservations> {
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String patientId;
  //------------------------------------------------------------------
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();
  //------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        selectNotificationSubject.add(payload);
      },
    );
  }

  //------------------------------------------------------------------
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  //-------------------------------------------------------------------
  @override
  void dispose() {
    super.dispose();
  }

  //------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    size: 25,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    _auth.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
          backgroundColor: Color(0xffEE2980),
          title: Text(
            'Reservations',
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _fireStore.collection('appointments').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blueAccent,
                ),
              );
            }
            //---------------------------------------------------
            final items = snapshot.data.documents.reversed;

            List<ReusablePatientCard> itemElements = [];

            for (var item in items) {
              if (loggedInUser.email == item.data['doctorId']) {
                patientId = item.data['patientId'];
                final reusableCard = ReusablePatientCard(
                  patientId: patientId,
                );
                itemElements.add(reusableCard);
              }
            }
            //---------------------------------------------------
            return (itemElements.length == 0)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(
                          Icons.warning,
                          color: Colors.yellow,
                          size: 200,
                        ),
                        Text(
                          'No reservations yet ..',
                          style: TextStyle(fontSize: 30, color: Colors.purple),
                        )
                      ],
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.all(15),
                    children: itemElements,
                  );
          },
        ),
      ),
    );
  }
}
