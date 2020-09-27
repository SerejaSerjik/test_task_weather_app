import 'package:flutter/foundation.dart';

abstract class RegisterEvent {}

class RegisterWithCredentialsPressed extends RegisterEvent {
  final String email;
  final String password;

  RegisterWithCredentialsPressed(
      {@required this.email, @required this.password});
}
