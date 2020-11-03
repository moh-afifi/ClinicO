import 'package:flutter/material.dart';

class ReusablePhotoCard extends StatelessWidget {
  ReusablePhotoCard({this.photo,this.onTap});
  final Widget photo;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          child: Card(
            elevation: 5.0,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: photo
            ),
          ),
        ),
      ),
    );
  }
}