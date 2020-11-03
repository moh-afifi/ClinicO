import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:medical/components/bloc.dart';
import 'package:medical/widgets/rounded_button.dart';
import 'package:connectivity/connectivity.dart';
import 'package:medical/screens/patient/patient_home.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:medical/reusables/reusable_photo_card.dart';
class RegisterPatient extends StatefulWidget {
  @override
  _RegisterPatientState createState() => _RegisterPatientState();
}

class _RegisterPatientState extends State<RegisterPatient> {
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  final bloc = Bloc();
  File _image;
  //------------------------------------------------
  Future getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      _image = File(image.path);
    });
  }
  //-----------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            ReusablePhotoCard(
              onTap: () {
                getImage();
              },
              photo: (_image != null)
                  ? Image.file(
                _image,
                fit: BoxFit.fill,
              )
                  : Icon(
                Icons.add_a_photo,
                size: 50,
                color: Colors.purple,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            StreamBuilder<String>(
              stream: bloc.name,
              builder: (context, snapshot) => TextField(
                onChanged: bloc.nameChanged,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "patient name",
                    labelText: "patient name",
                    errorText: snapshot.error),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            StreamBuilder<String>(
              stream: bloc.address,
              builder: (context, snapshot) => TextField(
                onChanged: bloc.addressChanged,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "patient address",
                    labelText: "patient address",
                    errorText: snapshot.error),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            StreamBuilder<String>(
              stream: bloc.id,
              builder: (context, snapshot) => TextField(
                onChanged: bloc.idChanged,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "patient ID",
                    labelText: "patient ID",
                    errorText: snapshot.error),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            StreamBuilder<String>(
              stream: bloc.phone,
              builder: (context, snapshot) => TextField(
                onChanged: bloc.phoneChanged,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Phone Number",
                    labelText: "phone number",
                    errorText: snapshot.error),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            StreamBuilder<String>(
              stream: bloc.birthday,
              builder: (context, snapshot) => TextField(
                onChanged: bloc.birthdayChanged,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter birthday",
                    labelText: "birthday",
                    errorText: snapshot.error),
              ),
            ),
            SizedBox(
              height: 20.0,
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
              height: 20.0,
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
              height: 10.0,
            ),
            RoundedButton(
              title: 'Sign Up',
              colour: Color(0xffEE2980),
              onPressed: () async {
                var connectivityResult =
                    await (Connectivity().checkConnectivity());

                if (bloc.getName == null ||
                    bloc.getPhone == null ||
                    bloc.getEmail == null ||
                    bloc.getPassword == null ||
                    bloc.getAddress == null ||
                    bloc.getID == null ||
                    bloc.getBirthday == null) {
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
                      //----------------------------------------
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: bloc.getEmail, password: bloc.getPassword);


                      DocumentReference docRef=Firestore.instance.collection("patientInfo").document();
                      DocumentSnapshot docSnap = await docRef.get();
                      var docId = docSnap.reference.documentID;
                      print('$docId ========');

                      if (newUser != null) {
                        final docRef = await _fireStore.collection('patientInfo').add({
                          'name': bloc.getName,
                          'phone': bloc.getPhone,
                          'address': bloc.getAddress,
                          'birthday':bloc.getBirthday,
                          'civilID':bloc.getID,
                          'id': 'patien${bloc.getEmail}',
                          'docId':'dsdsdsd'
                        });

                        docId= docRef.documentID;
                        await _fireStore.collection('patientInfo').document(docId).setData({
                          'name': bloc.getName,
                          'phone': bloc.getPhone,
                          'address': bloc.getAddress,
                          'birthday':bloc.getBirthday,
                          'civilID':bloc.getID,
                          'id': 'patien${bloc.getEmail}',
                          'docId':docId
                        });
                        //----------------------------------------
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientHome(),
                          ),
                        );
                        //----------------------------------------
                        setState(() {
                          showSpinner = false;
                        });
                        //----------------------------------------
                      }
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      if (e is PlatformException) {
                        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
                          Scaffold.of(context).showSnackBar(
                            new SnackBar(
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                              content: Text("Email alredy exists !"),
                            ),
                          );
                        } else {
                          Scaffold.of(context).showSnackBar(
                            new SnackBar(
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                              content: Text(
                                "Please, enter valid email and password !",
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          );
                        }
                      }
                    }
                  }
                }
                //-------------------------------------------------
              },
            ),
          ],
        ),
      ),
    );
  }
}
