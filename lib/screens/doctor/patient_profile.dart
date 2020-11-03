import 'package:flutter/material.dart';
import 'package:medical/reusables/reusable_column_patient.dart';
import 'package:medical/screens/doctor/med_history_doctor.dart';
import 'package:medical/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical/reusables/reusable_text_field.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:connectivity/connectivity.dart';
import 'package:medical/screens/doctor/emergency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class PatientProfile extends StatefulWidget {
  PatientProfile({this.patientId});
  final String patientId;
  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  String diagnosis = 'heart';
  String medicine = 'panadol';
  String amPm = 'AM';
  String hour, minute;
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String patientName, patientAge, patientPressure, patientTemp,date,doctorId;
  int pulse;
  List<String> diseaseList = [];
  List<String> medicineList = [];
  String textMedicine = '';
  String textDisease = '';
  //---------------------------------------------------
  void getPulse() async {
    await for (var snapshot in _fireStore.collection('pulse').snapshots()) {
      for (var message in snapshot.documents) {
        if (widget.patientId == message.data['patientId']) {
          pulse = message.data['pulse'];
          patientPressure = (message.data['pressure']).toString();
          patientTemp = (message.data['temp']).toString();
        }
      }
    }
  }
  //--------------------------------------------------
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        doctorId=loggedInUser.email;
      }
    } catch (e) {
      print(e);
    }
  }
  //--------------------------------------------------
  getDate() {
    initializeDateFormatting("en", null).then((_) {
      var now = DateTime.now();
      var formatter = DateFormat('d-M-y');
      date = formatter.format(now);
    });
  }
  //--------------------------------------------------
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  Future notifySchedule(String payload) async {
    var scheduledNotificationDateTime =
        new DateTime.now().add(new Duration(seconds: 10));
    var android1 = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION');
    var iOS1 = new IOSNotificationDetails();
    NotificationDetails platform = new NotificationDetails(android1, iOS1);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        '$medicine',
        'remember to take medicine at : $hour:$minute $amPm',
        scheduledNotificationDateTime,
        platform,
        payload: payload);
  }

  //------------------------------------------------
  @override
  void initState() {
    getPulse();
    getCurrentUser();
    getDate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //---------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffEE2980),
        title: Text(
          'Patient Profile',
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
                'Emergency',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
              trailing: CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.accessible,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Emergency(
                      patientId: widget.patientId,
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
                'Patient History',
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
                    builder: (context) => MedHistoryDoctor(doctorId: doctorId,),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return StreamBuilder<QuerySnapshot>(
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
                if (widget.patientId == (item.data['id']).substring(6)) {
                  patientName = item.data['name'];
                  patientAge = item.data['birthday'];
                }
              }
              return ListView(
                padding: EdgeInsets.all(15.5),
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Color(0xffEE2980),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Patient Name:',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        patientName,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xffEE2980),
                        ),
                      ),
                    ),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Color(0xffEE2980),
                    indent: 30,
                    endIndent: 30,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //-----------------------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ReusableColumnPatient(
                        label: 'Age',
                        containerText: patientAge,
                      ),
                      ReusableColumnPatient(
                        label: 'Pressure',
                        containerText: patientPressure,
                      ),
                      ReusableColumnPatient(
                        label: 'Temp',
                        containerText: patientTemp,
                      ),
                      (pulse == null)
                          ? SizedBox()
                          : ReusableColumnPatient(
                              label: 'Pulse',
                              containerText: pulse.toString(),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Color(0xffEE2980),
                    indent: 30,
                    endIndent: 30,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //-----------------------------------------------------------------
                  Text(
                    'Doctor Disease:',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple),
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    hint: Text('chooose'),
                    value: diagnosis,
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      setState(() {
                        diagnosis = newValue;
                        diseaseList.add(diagnosis);
                        textDisease = diseaseList
                            .toString()
                            .replaceAll("[", "")
                            .replaceAll("]", "");
                      });
                    },
                    items: ['heart', 'pressure', 'diabetes']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  (textDisease == '')
                      ? SizedBox()
                      : Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.red,
                          child: Text(
                            textDisease,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Choose Medicine:',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple),
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    hint: Text('chooose'),
                    value: medicine,
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      setState(() {
                        medicine = newValue;
                        medicineList.add(medicine);
                        textMedicine = medicineList
                            .toString()
                            .replaceAll("[", "")
                            .replaceAll("]", "");
                      });
                    },
                    items: <String>['panadol', 'congestal', 'flurest']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  (textMedicine == '')
                      ? SizedBox()
                      : Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.red,
                          child: Text(
                            textMedicine,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  //-----------------------------------------------------------------
                  Text(
                    'Medicine Time:',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                  Center(
                    child: RoundedButton(
                      title: 'Confirm',
                      colour: Colors.teal,
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
                          if ((connectivityResult !=
                                  ConnectivityResult.mobile) &&
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
                            notifySchedule('remember at : $hour-$minute-$amPm');

                            await _fireStore.collection('chronic').add({
                              'name': patientName,
                              'pressure': patientPressure,
                              'temp': patientTemp,
                              'age': patientAge,
                              'pulse': pulse,
                              'patientId': widget.patientId,
                              'doctorId': loggedInUser.email,
                              'disease': textDisease,
                              'medicine': textMedicine,
                              'hour': hour,
                              'minute': minute,
                              'amPm': amPm,
                              'date':date
                            });
                            //------------------------------------------------------
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Center(
                                    child: Text(
                                  'Complete',
                                  style: TextStyle(color: Colors.teal),
                                )),
                                content: Text(
                                  'Medicine has been assigned',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xffEE2980)),
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
                          }
                        }
                        //----------------------------------------------
                      },
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
