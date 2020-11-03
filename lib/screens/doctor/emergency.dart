import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical/widgets/emergency_card.dart';

class Emergency extends StatefulWidget {
  Emergency({this.patientId});
  final String patientId;
  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  final _fireStore = Firestore.instance;
  String pulse, pressure, temp, name, docId;
  //----------------------------------------------------
  getPatientInfo() async {
    await for (var snapshot
        in _fireStore.collection('patientInfo').snapshots()) {
      for (var message in snapshot.documents) {
        if ('patien${widget.patientId}' == message.data['id']) {
          name = message.data['name'];
        }
      }
    }
  }

  //--------------------------------------------------------
  @override
  void initState() {
    getPatientInfo();
    super.initState();
  }

  //-----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffEE2980),
        title: Text(
          'Emergency',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: _fireStore.collection('emergency').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueAccent,
                  ),
                );
              }

              final items = snapshot.data.documents.reversed;

              List<EmergencyCard> itemElements = [];

              for (var item in items) {
                pressure = (item.data['pressure']).toString();
                pulse = (item.data['pulse']).toString();
                temp = (item.data['temp']).toString();
                docId = item.data['docId'];
                final reusableCard = EmergencyCard(
                  name: name,
                  pressure: pressure,
                  pulse: pulse,
                  temp: temp,
                  docId: docId,
                );
                itemElements.add(reusableCard);
              }
              return (pressure == null)
                  ? Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
                          CircleAvatar(
                            child: Icon(
                              Icons.warning,
                              color: Colors.white,
                              size: 50,
                            ),
                            radius: 50,
                            backgroundColor: Colors.yellow,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            'No Emergency yet ..',
                            style:
                                TextStyle(fontSize: 30, color: Colors.purple),
                          )
                        ],
                      ),
                    )
                  : Expanded(
                      child: ListView(
                        padding: EdgeInsets.all(15),
                        children: itemElements,
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
