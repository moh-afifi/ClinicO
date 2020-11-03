import 'package:flutter/material.dart';
import 'package:medical/screens/patient/make_appointment.dart';

class DoctorCard extends StatelessWidget {
  DoctorCard({this.doctorName, this.doctorId, this.photoUrl});
  final String doctorName;
  final String doctorId;
  final String photoUrl;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(13.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MakeAppointment(
                doctorId: doctorId,
                doctorName: doctorName,
                photoUrl:photoUrl
              ),
            ),
          );
        },
        child: Card(
          elevation: 10.0,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleAvatar(
                  radius: 35,
                  backgroundImage: (photoUrl == null)
                      ? AssetImage('images/person2.png')
                      : NetworkImage(photoUrl),
                ),
                Text(
                  'Dr. $doctorName',
                  style: TextStyle(fontSize: 20),
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xffEE2980),
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
