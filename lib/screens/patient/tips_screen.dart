import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffEE2980),
        title: Text(
          'Tips for You',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('tip1',style: TextStyle(fontSize: 25),),
            Text('tip2',style: TextStyle(fontSize: 25),),
            Text('tip3',style: TextStyle(fontSize: 25),),
          ],
        ),
      ),
    );
  }
}
