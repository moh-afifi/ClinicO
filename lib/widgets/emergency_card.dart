import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class EmergencyCard extends StatelessWidget {
  EmergencyCard({this.pulse, this.pressure, this.name, this.temp,this.docId});
  final String name, pulse, pressure, temp,docId;
  final _fireStore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Text(
              'Patient Name: $name',
              style: TextStyle(fontSize: 20, color: Colors.purple),
            ),
            Divider(
              color: Colors.black,
              endIndent: 50,
              indent: 50,
            ),
            Row(
              children: <Widget>[
                Text(
                  'pulse: $pulse',
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Pressure: $pressure',
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Temp: $temp',
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
                size: 40,
              ),
              onPressed: () async{
                await _fireStore
                    .collection('emergency')
                    .document(docId)
                    .delete();
              },
            )
          ],
        ),
      ),
    );
  }
}
