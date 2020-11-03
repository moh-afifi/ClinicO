import 'package:flutter/material.dart';

class ReusableColumnPatient extends StatelessWidget {
  ReusableColumnPatient({this.label,this.containerText});
  final String label;
  final String containerText;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(label,style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
        SizedBox(height: 5,),
        Container(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(containerText,style: TextStyle(fontSize: 20,color: Color(0xffEE2980),),),
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey)
          ),
        ),
      ],
    );
  }
}