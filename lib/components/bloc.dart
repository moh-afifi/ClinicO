import 'dart:async';
import 'validator.dart';
import 'package:rxdart/rxdart.dart';

class Bloc extends Object with Validators implements BaseBloc {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _phoneController = BehaviorSubject<String>();
  final _addressController = BehaviorSubject<String>();
  final _birthdayController = BehaviorSubject<String>();
  final _idController = BehaviorSubject<String>();

  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;
  Function(String) get nameChanged => _nameController.sink.add;
  Function(String) get phoneChanged => _phoneController.sink.add;
  Function(String) get addressChanged => _addressController.sink.add;
  Function(String) get birthdayChanged => _birthdayController.sink.add;
  Function(String) get idChanged => _idController.sink.add;

  //Another way
//   StreamSink<String> get emailChanged => _emailController.sink;
//   StreamSink<String> get passwordChanged => _passwordController.sink;

  Stream<String> get email => _emailController.stream.transform(emailValidator);
  Stream<String> get password => _passwordController.stream.transform(passwordValidator);
  Stream<String> get name => _nameController.stream.transform(nameValidator);
  Stream<String> get phone => _phoneController.stream.transform(phoneValidator);
  Stream<String> get address => _addressController.stream.transform(addressValidator);
  Stream<String> get birthday => _birthdayController.stream.transform(birthdayValidator);
  Stream<String> get id => _idController.stream.transform(idValidator);


  String get getEmail => _emailController.value;
  String get getPassword => _passwordController.value;
  String get getName => _nameController.value;
  String get getPhone => _phoneController.value;
  String get getAddress=> _addressController.value;
  String get getBirthday=> _birthdayController.value;
  String get getID=> _idController.value;


  @override
  void dispose() {
    _emailController?.close();
    _passwordController?.close();
    _nameController?.close();
    _phoneController?.close();
    _addressController?.close();
    _birthdayController?.close();
    _idController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}