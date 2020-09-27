import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final User user;

  LoggedIn({@required this.user});
}

class LoggedOut extends AuthEvent {}
