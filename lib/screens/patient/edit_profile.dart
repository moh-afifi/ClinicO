import 'package:flutter/material.dart';
import 'package:medical/widgets/edit_profile_card.dart';
import 'package:medical/screens/patient/edit_profile_screen.dart';
class EditProfile extends StatefulWidget {
  EditProfile(
      {this.name, this.address, this.phone, this.birthday, this.civilID,this.docID});
  final String name;
  final String address;
  final String phone;
  final String civilID;
  final String birthday;
  final String docID;
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  void editProfile(String label) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>EditProfileDialog(
            label: label,docId: widget.docID,
      ),
    ),);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffEE2980),
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          EditProfileCard(
            label: 'Name',
            name: widget.name,
            onPressed: () {
              editProfile('name');

              },
          ),
          EditProfileCard(
            label: 'Address',
            name: widget.address,
            onPressed: () {
              editProfile('address');

            },
          ),
          EditProfileCard(
            label: 'Phone',
            name: widget.phone,
            onPressed: () {
              editProfile('phone');

            },
          ),
          EditProfileCard(
            label: 'Civil ID',
            name:widget.civilID,
            onPressed: () {
              editProfile('civilID');

            },
          ),
          EditProfileCard(
            label: 'Birthday',
            name: widget.birthday,
            onPressed: () {
              editProfile('birthday');

            },
          ),
        ],
      ),
    );
  }
}
