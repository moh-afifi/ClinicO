import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  HistoryCard(
      {this.name,
      this.date,
      this.amPm,
      this.minute,
      this.hour,
      this.pulse,
      this.pressure,
      this.medicine,
      this.disease,
      this.temp,
      this.age});
  final String name,
      age,
      pulse,
      pressure,
      temp,
      medicine,
      disease,
      date,
      hour,
      minute,
      amPm;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12.0),
      elevation: 10.0,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: $name ',style: TextStyle(fontSize: 20,color: Colors.purple),),
            Text('Age: $age',style: TextStyle(fontSize: 20,color: Colors.purple),),
            Text('Pulse: $pulse',style: TextStyle(fontSize: 20,color: Colors.purple),),
            Text('Pressure: $pressure',style: TextStyle(fontSize: 20,color: Colors.purple),),
            Text('Temp: $temp',style: TextStyle(fontSize: 20,color: Colors.purple),),
            Text('Disease: $disease',style: TextStyle(fontSize: 18,color: Colors.purple),),
            Text('Medicine: $medicine',style: TextStyle(fontSize: 18,color: Colors.purple),),
            Text('Medicine Time: $hour:$minute:$amPm',style: TextStyle(fontSize: 20,color: Colors.purple),),
            Text('Date: $date',style: TextStyle(fontSize: 20,color: Colors.purple),),
          ],
        ),
      ),
    );
  }
}
