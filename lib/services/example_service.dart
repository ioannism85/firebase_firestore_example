import 'package:flutter/material.dart';

class ExampleService  with ChangeNotifier {


  String _message= "Initial message";

  String get message => _message;

  void setMessage(String message){
    _message = message;
    notifyListeners();
  } 

}