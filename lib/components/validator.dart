import 'dart:async';

mixin Validators{

  var emailValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (email,sink){
        if((email.contains('@'))&&email.contains('.')){
          sink.add(email);
        }
        else{
          sink.addError("Email is not valid");
        }
      }
  );

  var passwordValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (password,sink){
        if(password.length > 5){
          sink.add(password);
        }else{
          sink.addError("Password length can\'t be less than 6 chars.");
        }
      }
  );


  var nameValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (name,sink){
        if(name.isNotEmpty){
          sink.add(name);
        }else{
          sink.addError("enter your name");
        }
      }
  );


  var phoneValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (phone,sink){
        if(phone.isNotEmpty){
          sink.add(phone);
        }else{
          sink.addError("enter your phone number");
        }
      }
  );
  var addressValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (address,sink){
        if(address.isNotEmpty){
          sink.add(address);
        }else{
          sink.addError("enter your address");
        }
      }
  );
  var birthdayValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (birthday,sink){
        if(birthday.isNotEmpty){
          sink.add(birthday);
        }else{
          sink.addError("enter your birthday");
        }
      }
  );
  var idValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (id,sink){
        if(id.isNotEmpty){
          sink.add(id);
        }else{
          sink.addError("enter your id");
        }
      }
  );


}