import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical/screens/patient/patient_home.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditProfileDialog extends StatefulWidget {
  EditProfileDialog({this.label, this.docId});
  final String label;
  final String docId;
  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _fireStore = Firestore.instance;
  String newVal;
  bool showSpinner =false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffEE2980),
        centerTitle: true,
        title: Text('Update'),
      ),
      body: Builder(
        builder: (context) => ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: ListView(
            padding: EdgeInsets.all(25.0 ),
            children: <Widget>[
              Text(
                'Update:',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30,),
              TextFormField(
                textAlign: TextAlign.start,
                onChanged: (value) {
                  newVal = value;
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: widget.label,
                  labelText: widget.label,
                ),
              ),
              SizedBox(height: 30,),
              FlatButton(
                color: Colors.teal,
                child: Text(
                  'ok',
                  style: TextStyle(fontSize: 20,color: Colors.white),
                ),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  await _fireStore
                      .collection('patientInfo')
                      .document(widget.docId)
                      .updateData({
                    '${widget.label}': newVal,
                  });

                  setState(() {
                    showSpinner = false;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientHome(),
                    ),
                  );
                  //-------------------------------------------
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
