import 'package:flutter/material.dart';
import 'package:medical/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical/reusables/reusable_text_field.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:connectivity/connectivity.dart';

class MakeAppointment extends StatefulWidget {
  MakeAppointment({this.doctorId, this.doctorName, this.photoUrl});
  final String doctorId;
  final String doctorName;
  final String photoUrl;
  @override
  _MakeAppointmentState createState() => _MakeAppointmentState();
}

class _MakeAppointmentState extends State<MakeAppointment> {
  String amPm = 'AM';
  String hour, minute;
  FirebaseUser loggedInUser;
  final _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  bool showSpinner = false;
  String docId;
  //-------------------------------------------------
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  Future notifySchedule(String payload) async {
    var scheduledNotificationDateTime =
        new DateTime.now().add(new Duration(seconds: 10));
    var android1 = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION');
    var iOS1 = new IOSNotificationDetails();
    NotificationDetails platform = new NotificationDetails(android1, iOS1);
    await flutterLocalNotificationsPlugin.schedule(0, 'Pulse Measure',
        'Please, measure your pulse! ', scheduledNotificationDateTime, platform,
        payload: payload);
  }

  //------------------------------------------------
  @override
  void initState() {
    getCurrentUser();
//    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
//    var iOS = new IOSInitializationSettings();
//    var initSettings = new InitializationSettings(android, iOS);
//    flutterLocalNotificationsPlugin.initialize(initSettings,
//        onSelectNotification: notifySchedule);
    super.initState();
  }

  //---------------------------------------------
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

  //---------------------------------------------
  @override
  void dispose() {
    super.dispose();
  }

  //---------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffEE2980),
        title: Text(
          'Appointment',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Builder(builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            //padding: EdgeInsets.all(20.0),
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                height: 150,
                width: 150,
                child: Card(
                  elevation: 10,
                  child: (widget.photoUrl == null)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'images/person2.png',
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            widget.photoUrl,
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Dr.${widget.doctorName}',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color(0xffEE2980),
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Color(0xffEE2980),
                indent: 50,
                endIndent: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Set Appointment:',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                color: Colors.lightBlueAccent,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ReusableTextField(
                    label: 'hour',
                    onChanged: (val) {
                      hour = val;
                    },
                  ),
                  ReusableTextField(
                    label: 'minute',
                    onChanged: (val) {
                      minute = val;
                    },
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    child: DropdownButton<String>(
                      underline: Container(),
                      hint: Text('chooose'),
                      value: amPm,
                      icon: Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String newValue) {
                        setState(() {
                          amPm = newValue;
                        });
                      },
                      items: <String>['AM', 'PM']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //----------------------------------------------
              RoundedButton(
                colour: Colors.teal,
                title: 'confirm',
                onPressed: () async {
                  var connectivityResult =
                      await (Connectivity().checkConnectivity());

                  if ((hour == null) || (minute == null)) {
                    Scaffold.of(context).showSnackBar(
                      new SnackBar(
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                        content: Text(
                          "All fields must be filled !",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    );
                  } else {
                    if ((connectivityResult != ConnectivityResult.mobile) &&
                        (connectivityResult != ConnectivityResult.wifi)) {
                      Scaffold.of(context).showSnackBar(
                        new SnackBar(
                          backgroundColor: Colors.black,
                          duration: Duration(seconds: 2),
                          content: Text(
                            "No internet Connection !",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Center(
                              child: Text(
                            'Complete',
                            style: TextStyle(color: Colors.teal),
                          )),
                          content: Text(
                            'Your booking is done!',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xffEE2980),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          elevation: 8.0,
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Ok',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      );
                      notifySchedule('please, measure your pulse! ');

                      _fireStore.collection('appointments').add({
                        'hour': hour,
                        'minute': minute,
                        'amPm': amPm,
                        'doctorId': widget.doctorId,
                        'patientId': loggedInUser.email
                      });
                      //---------------------------------------------------------------------------
                      final docRef = await _fireStore
                          .collection('PatientAppointments')
                          .add({
                        'hour': hour,
                        'minute': minute,
                        'amPm': amPm,
                        'doctorName': widget.doctorName,
                        'patientId': loggedInUser.email
                      });
                      docId = docRef.documentID;
                      _fireStore
                          .collection('PatientAppointments')
                          .document(docId)
                          .setData({
                        'hour': hour,
                        'minute': minute,
                        'amPm': amPm,
                        'doctorName': widget.doctorName,
                        'patientId': loggedInUser.email,
                        'docId': docId
                      });
                    }
                  }
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        );
      }),
    );
  }
}
