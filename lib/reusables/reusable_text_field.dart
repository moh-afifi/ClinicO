import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  ReusableTextField({this.label,this.onChanged});
  final String label;
  final Function onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: TextField(
        onChanged: onChanged,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: label,
          labelText: label,
        ),
      ),
    );
  }
}
