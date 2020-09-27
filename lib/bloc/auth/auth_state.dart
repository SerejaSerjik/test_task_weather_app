abstract class AuthState {}

class Uninitialized extends AuthState {}

class Authenticated extends AuthState {
  final String displayName;

  Authenticated(this.displayName);
}

class Unauthenticated extends AuthState {}
