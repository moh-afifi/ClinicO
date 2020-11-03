import 'package:flutter/material.dart';
import 'package:medical/reusables/reusable_doctor_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical/screens/app_screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical/screens/patient/med_history_patient.dart';
import 'package:medical/screens/patient/pulse_home.dart';
import 'package:medical/screens/patient/tips_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:medical/screens/patient/edit_profile.dart';
import 'package:medical/screens/patient/patient_reservations.dart';

class PatientHome extends StatefulWidget {
  @override
  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  String doctorName, doctorId, photoUrl;
  FirebaseUser loggedInUser;
  String name, phone, address, civilId, birthday, docId,patientId;
  //----------------------------------------------------
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();
  //----------------------------------------------------
  getPatientInfo() async {
    await for (var snapshot
        in _fireStore.collection('patientInfo').snapshots()) {
      for (var message in snapshot.documents) {
        if ('patien${loggedInUser.email}' == message.data['id']) {
          name = message.data['name'];
          address = message.data['address'];
          phone = message.data['phone'];
          birthday = message.data['birthday'];
          civilId = message.data['civilID'];
          docId = message.data['docId'];
        }
      }
    }
  }

  //-----------------------------------------------------
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getPatientInfo();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      selectNotificationSubject.add(payload);
    });
  }

  //--------------------------------------------------
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        patientId=loggedInUser.email;
      }
    } catch (e) {
      print(e);
    }
  }

  //--------------------------------------------------
  @override
  void dispose() {
    super.dispose();
  }

  //-------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
          appBar: AppBar(
            //automaticallyImplyLeading: false,
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
                    onPressed: () {
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
              'Patient Home',
              style: TextStyle(fontSize: 30),
            ),
            centerTitle: true,
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                AppBar(
                  title: Text('Medical'),
                  backgroundColor: Color(0xffEE2980),
                ),
                SizedBox(
                  height: 40,
                ),
                ListTile(
                  title: Text(
                    'Measure Pulse',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.show_chart,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PulseHome(
                          patientId: loggedInUser.email,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.black,
                  indent: 20,
                  endIndent: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Text(
                    'Tips for you ..',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.info,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TipsScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.black,
                  indent: 20,
                  endIndent: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Text(
                    'edit your profile',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfile(
                          name: name,
                          phone: phone,
                          address: address,
                          birthday: birthday,
                          civilID: civilId,
                          docID: docId,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.black,
                  indent: 20,
                  endIndent: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Text(
                    'My Reservations',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.bookmark_border,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientReservations(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.black,
                  indent: 20,
                  endIndent: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Text(
                    'My History',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.history,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedHistory(patientId: patientId,),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          body: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: _fireStore.collection('doctorInfo').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blueAccent,
                      ),
                    );
                  }

                  final items = snapshot.data.documents.reversed;

                  List<DoctorCard> itemElements = [];

                  for (var item in items) {
                    doctorName = item.data['name'];
                    doctorId = (item.data['id']).substring(6);
                    photoUrl = item.data['url'];
                    final reusableCard = DoctorCard(
                      doctorName: doctorName,
                      doctorId: doctorId,
                      photoUrl: photoUrl,
                    );
                    itemElements.add(reusableCard);
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
          )),
    );
  }
}
