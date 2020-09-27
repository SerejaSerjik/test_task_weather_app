import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weather_app/bloc/auth/auth.dart';
import 'package:weather_app/bloc/login/login.dart';
import 'package:weather_app/services/auth_service.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService;
  final AuthBloc _authBloc;

  LoginBloc({
    @required AuthBloc authBloc,
    @required AuthService authService,
  })  : assert(authService != null),
        assert(authBloc != null),
        _authBloc = authBloc,
        _authService = authService,
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsToState(event);
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressed(event);
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsToState(
      LoginWithCredentialsPressed event) async* {
    yield LoginLoading();
    try {
      final user =
          await _authService.signInWithCredentials(event.email, event.password);
      if (user != null) {
        // push new authentication event
        _authBloc.add(LoggedIn(user: user));
        yield LoginSuccess();
        yield LoginInitial();
      } else {
        yield LoginFailure(error: 'Something very weird just happened');
      }
    } on FirebaseAuthException catch (e) {
      yield LoginFailure(error: e.message);
    } catch (err) {
      yield LoginFailure(error: err.message ?? 'An unknown error occured');
    }
  }

  Stream<LoginState> _mapLoginWithGooglePressed(
      LoginWithGooglePressed event) async* {
    yield LoginLoading();
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        // push new authentication event
        _authBloc.add(LoggedIn(user: user));
        yield LoginSuccess();
        yield LoginInitial();
      } else {
        yield LoginFailure(error: 'Something very weird just happened');
      }
    } on FirebaseAuthException catch (e) {
      yield LoginFailure(error: e.message);
    } catch (err) {
      yield LoginFailure(error: err.message ?? 'An unknown error occured');
    }
  }
}
