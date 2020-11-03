//import 'package:flutter/material.dart';
//import 'package:medical/widgets/rounded_button.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:medical/screens/patient_home.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';
//import 'package:medical/screens/register.dart';
//import 'package:connectivity/connectivity.dart';
//import 'package:medical/components/bloc.dart';
//import 'package:medical/screens/doctor_reservations.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//
//class LoginScreen extends StatefulWidget {
//  @override
//  _LoginScreenState createState() => _LoginScreenState();
//}
//
//class _LoginScreenState extends State<LoginScreen> {
//  final bloc = Bloc();
//  bool showSpinner = false;
//  final _auth = FirebaseAuth.instance;
//  final _fireStore = Firestore.instance;
//  String email;
//  String password;
//  bool checked = false;
//  String isDoctor, isPatient;
//  //-------------------------------------
//  Future<String> checkDoctor(String email) async {
//    String txt;
//    await for (var snapshot
//    in _fireStore.collection('doctorInfo').snapshots()) {
//      for (var message in snapshot.documents) {
//        if ('doctor$email' == message.data['id']) {
//          txt = 'doctor';
//        }
//      }
//    }
//    return txt;
//  }
//
//  //--------------------------------------
//  Future<String> checkPatient(String email) async {
//    String txt;
//    await for (var snapshot
//    in _fireStore.collection('patientInfo').snapshots()) {
//      for (var message in snapshot.documents) {
//        if ('patien$email' == message.data['id']) {
//          txt = 'patient';
//        }
//      }
//    }
//    return txt;
//  }
//
//  //--------------------------------------
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//      onWillPop: () {},
//      child: Scaffold(
//        backgroundColor: Colors.white,
//        appBar: AppBar(
//          centerTitle: true,
//          leading: SizedBox(),
//          backgroundColor: Color(0xffEE2980),
//          title: Text(
//            "Login",
//            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
//          ),
//        ),
//        body: Builder(
//          builder: (context) => ModalProgressHUD(
//            inAsyncCall: showSpinner,
//            child: ListView(
//              padding: EdgeInsets.all(20),
//              children: <Widget>[
//                Image(
//                  image: AssetImage('images/logo.png'),
//                  height: 300,
//                  width: 200,
//                ),
//                SizedBox(
//                  height: 15.0,
//                ),
//                StreamBuilder<String>(
//                  stream: bloc.email,
//                  builder: (context, snapshot) => TextField(
//                    onChanged: bloc.emailChanged,
//                    keyboardType: TextInputType.emailAddress,
//                    decoration: InputDecoration(
//                        border: OutlineInputBorder(),
//                        hintText: "Enter email",
//                        labelText: "Email",
//                        errorText: snapshot.error),
//                  ),
//                ),
//                SizedBox(
//                  height: 30.0,
//                ),
//                StreamBuilder<String>(
//                  stream: bloc.password,
//                  builder: (context, snapshot) => TextField(
//                    onChanged: bloc.passwordChanged,
//                    keyboardType: TextInputType.text,
//                    obscureText: true,
//                    decoration: InputDecoration(
//                        border: OutlineInputBorder(),
//                        hintText: "Enter password",
//                        labelText: "Password",
//                        errorText: snapshot.error),
//                  ),
//                ),
//                SizedBox(
//                  height: 30.0,
//                ),
//
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    (checked)
//                        ? IconButton(
//                      icon: Icon(
//                        Icons.check_box,
//                        color: Color(0xffEE2980),
//                        size: 40,
//                      ),
//                      onPressed: () {
//                        setState(() {
//                          checked = !checked;
//                        });
//                      },
//                    )
//                        : IconButton(
//                      icon: Icon(
//                        Icons.check_box_outline_blank,
//                        color: Color(0xffEE2980),
//                        size: 40,
//                      ),
//                      onPressed: () {
//                        setState(() {
//                          checked = !checked;
//                        });
//                      },
//                    ),
//                    SizedBox(
//                      width: 5,
//                    ),
//                    Text(
//                      'Doctor',
//                      style: TextStyle(
//                        fontSize: 25,
//                        color: Color(0xffEE2980),
//                      ),
//                    ),
//                    SizedBox(
//                      width: 40,
//                    ),
//                    (checked)
//                        ? IconButton(
//                      icon: Icon(
//                        Icons.check_box_outline_blank,
//                        color: Color(0xffEE2980),
//                        size: 40,
//                      ),
//                      onPressed: () {
//                        setState(() {
//                          checked = !checked;
//                        });
//                      },
//                    )
//                        : IconButton(
//                      icon: Icon(
//                        Icons.check_box,
//                        color: Color(0xffEE2980),
//                        size: 40,
//                      ),
//                      onPressed: () {
//                        setState(() {
//                          checked = !checked;
//                        });
//                      },
//                    ),
//                    Text(
//                      'Patient',
//                      style: TextStyle(
//                        fontSize: 25,
//                        color: Color(0xffEE2980),
//                      ),
//                    ),
//                  ],
//                ),
//                RoundedButton(
//                  title: 'Login',
//                  colour: Colors.teal,
//                  onPressed: () async {
//                    var connectivityResult =
//                    await (Connectivity().checkConnectivity());
//                    try {
//                      setState(() {
//                        showSpinner = true;
//                      });
//                      if ((connectivityResult == ConnectivityResult.mobile) ||
//                          (connectivityResult == ConnectivityResult.wifi)) {
//
//                        isDoctor = await checkDoctor(bloc.getEmail);
//                        isPatient = await checkPatient(bloc.getEmail);
//                        print(isDoctor);
//                        print(isPatient);
//                        if (isDoctor == 'doctor') {
//                          await _auth.signInWithEmailAndPassword(
//                              email: bloc.getEmail, password: bloc.getPassword);
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => DoctorReservations(),
//                            ),
//                          );
//                        } else if (isPatient == 'patient') {
//                          await _auth.signInWithEmailAndPassword(
//                              email: bloc.getEmail, password: bloc.getPassword);
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => PatientHome(),
//                            ),
//                          );
//                        }
////                        (!checked)
////                            ? Navigator.push(
////                                context,
////                                MaterialPageRoute(
////                                  builder: (context) => PatientHome(),
////                                ),
////                              )
////                            : Navigator.push(
////                                context,
////                                MaterialPageRoute(
////                                  builder: (context) => DoctorReservations(),
////                                ),
////                              );
//                      }
//                      setState(() {
//                        showSpinner = false;
//                      });
//                      //------------------------------------------------------------
//                    } catch (e) {
//                      setState(() {
//                        showSpinner = false;
//                      });
//                      if ((connectivityResult != ConnectivityResult.mobile) &&
//                          (connectivityResult != ConnectivityResult.wifi)) {
//                        Scaffold.of(context).showSnackBar(new SnackBar(
//                          backgroundColor: Colors.black,
//                          duration: Duration(seconds: 3),
//                          content: Text(
//                            "No internet Connection !",
//                            style: TextStyle(fontSize: 17),
//                          ),
//                        ));
//                      } else {
//                        Scaffold.of(context).showSnackBar(new SnackBar(
//                          backgroundColor: Colors.red,
//                          duration: Duration(seconds: 3),
//                          content:
//                          Text("Please, Enter a valid email and passowrd!"),
//                        ));
//                      }
//                    }
//                  },
//                ),
//                SizedBox(
//                  height: 30.0,
//                ),
//                //--------------------------------------------
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Text(
//                      'Don\'t have an account?',
//                      style: TextStyle(
//                        color: Color(0xffEE2980),
//                        fontSize: 15,
//                      ),
//                    ),
//                    SizedBox(
//                      width: 10,
//                    ),
//                    InkWell(
//                      onTap: () {
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                            builder: (context) => RegistrationScreen(),
//                          ),
//                        );
//                      },
//                      child: Text(
//                        'Register Here',
//                        style: TextStyle(
//                            color: Color(0xffEE2980),
//                            decoration: TextDecoration.underline,
//                            fontWeight: FontWeight.bold,
//                            fontSize: 20),
//                      ),
//                    )
//                  ],
//                ),
//                SizedBox(
//                  height: 15,
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
