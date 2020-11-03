import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:medical/components/bloc.dart';
import 'package:medical/widgets/rounded_button.dart';
import 'package:connectivity/connectivity.dart';
import 'package:medical/screens/doctor/doctor_reservations.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:medical/reusables/reusable_photo_card.dart';

class RegisterDoctor extends StatefulWidget {
  @override
  _RegisterDoctorState createState() => _RegisterDoctorState();
}

class _RegisterDoctorState extends State<RegisterDoctor> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  bool showSpinner = false;
  final bloc = Bloc();
  File _image;
  String downloadUrl;
  //-------------------------------------------------
  Future getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    await uploadTask.onComplete;
    String downloadAddress = await firebaseStorageRef.getDownloadURL();
      downloadUrl = downloadAddress;
  }
  //-------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            Text(
              'Add profile photo:',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xffEE2980),
              ),
            ),
            SizedBox(
              height: 10.0,
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
                    hintText: "doctor Name",
                    labelText: "doctor name",
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
                    hintText: "phone number",
                    labelText: "phone number",
                    errorText: snapshot.error),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            //-------------------------------------------------------
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
              height: 20.0,
            ),
            //-------------------------------------------------------
            RoundedButton(
              title: 'Sign UP',
              colour: Color(0xffEE2980),
              onPressed: () async {
                var connectivityResult =
                    await (Connectivity().checkConnectivity());
                //-----------------------------------------------
                if (bloc.getName == null ||
                    bloc.getPhone == null ||
                    bloc.getEmail == null ||
                    bloc.getPassword == null) {
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
                }else{
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
                      final newUser = await _auth.createUserWithEmailAndPassword(
                          email: bloc.getEmail, password: bloc.getPassword);
                      if (newUser != null) {
                        if(_image != null){
                          await uploadPic(context);
                        }
                        await _fireStore.collection('doctorInfo').add({
                          'name': bloc.getName,
                          'phone': bloc.getPhone,
                          'id': 'doctor${bloc.getEmail}',
                          'url': downloadUrl
                        });
                        //----------------------------------------------
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorReservations(),
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
                      //----------------------------------------
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
                //--------------------------------------------------------------
              },
            ),
          ],
        ),
      ),
    );
  }
}
