import 'package:flutter/material.dart';
import 'package:medical/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical/screens/patient/patient_home.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:medical/screens/app_screens/register.dart';
import 'package:connectivity/connectivity.dart';
import 'package:medical/components/bloc.dart';
import 'package:medical/screens/doctor/doctor_reservations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final bloc = Bloc();
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  String email;
  String password;
  String isDoctor, isPatient;
  //-------------------------------------
//  checkDoctor(String email) async {
//    await for (var snapshot
//        in _fireStore.collection('doctorInfo').snapshots()) {
//      for (var message in snapshot.documents) {
//        if ('doctor$email' == message.data['id']) {
//          setState(() {
//            _txt = 'doctor';
//          });
//        }
//      }
//    }
//  }
//
//  //--------------------------------------
//  checkPatient(String email) async {
//    await for (var snapshot
//        in _fireStore.collection('patientInfo').snapshots()) {
//      for (var message in snapshot.documents) {
//        if ('patien$email' == message.data['id']) {
//          setState(() {
//            _txt = 'patient';
//          });
//        }
//      }
//    }
//  }

  //--------------------------------------
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: SizedBox(),
          backgroundColor: Color(0xffEE2980),
          title: Text(
            "Login",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        body: Builder(
          builder: (context) => ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                Image(
                  image: AssetImage('images/logo.png'),
                  height: 200,
                  width: 50,
                ),
                SizedBox(
                  height: 15.0,
                ),
                StreamBuilder<String>(
                  stream: bloc.email,
                  builder: (context, snapshot) => TextField(
                    onChanged: bloc.emailChanged,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter email",
                        labelText: "Email",
                        errorText: snapshot.error),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                StreamBuilder<String>(
                  stream: bloc.password,
                  builder: (context, snapshot) => TextField(
                    onChanged: bloc.passwordChanged,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter password",
                        labelText: "Password",
                        errorText: snapshot.error),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                StreamBuilder<QuerySnapshot>(
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
                      if ('patien${bloc.getEmail}' == (item.data['id'])) {
                        isPatient = 'patient';
                      }
                    }
                    return SizedBox();
                  },
                ),
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

                    final items = snapshot.data.documents;

                    for (var item in items) {
                      if ('doctor${bloc.getEmail}' == (item.data['id'])) {
                        isDoctor = 'doctor';
                      }
                    }
                    return SizedBox();
                  },
                ),
                RoundedButton(
                  title: 'Login',
                  colour: Color(0xffEE2980),
                  onPressed: () async {
                    var connectivityResult =
                        await (Connectivity().checkConnectivity());
                    //---------------------------------------------------
                    if (bloc.getEmail == null || bloc.getPassword == null) {
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
                        try {
                          setState(() {
                            showSpinner = true;
                          });
                          final user = await _auth.signInWithEmailAndPassword(
                              email: bloc.getEmail, password: bloc.getPassword);

                          if (user != null) {
                            if (isDoctor == 'doctor') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DoctorReservations(),
                                ),
                              );
                            } else if (isPatient == 'patient') {
                              await _auth.signInWithEmailAndPassword(
                                  email: bloc.getEmail,
                                  password: bloc.getPassword);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientHome(),
                                ),
                              );
                            }
                          }
                          setState(() {
                            showSpinner = false;
                          });
                          //------------------------------------------------------------
                        } catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          Scaffold.of(context).showSnackBar(new SnackBar(
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                            content: Text(
                                "Please, Enter a valid email and passowrd!"),
                          ));
                        }
                      }
                    }
                    //---------------------------------------------------
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                //--------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: Color(0xffEE2980),
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Register Here',
                        style: TextStyle(
                            color: Colors.purple,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
