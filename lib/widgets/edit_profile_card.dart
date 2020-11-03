import 'package:flutter/material.dart';

class EditProfileCard extends StatelessWidget {
  EditProfileCard({this.name,this.onPressed,this.label});
  final String name;
  final Function onPressed;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('$label : ',style: TextStyle(color: Colors.black,fontSize: 25),),
        Card(
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                 name,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xffEE2980),
                  ),
                ),
                IconButton(
                  onPressed:onPressed,
                  icon: Icon(
                    Icons.edit,
                    color: Color(0xffEE2980),
                    size: 40,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
