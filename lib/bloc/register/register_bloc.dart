import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/services/auth_service.dart';

import './register.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService _authService;

  RegisterBloc({@required AuthService authService})
      : assert(authService != null),
        _authService = authService,
        super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterWithCredentialsPressed) {
      yield* _mapRegisterWithCredentialsToState(event);
    }
  }

  Stream<RegisterState> _mapRegisterWithCredentialsToState(
      RegisterWithCredentialsPressed event) async* {
    yield RegisterLoading();
    try {
      final user = await _authService.signUp(
          email: event.email, password: event.password);
      if (user != null) {
        yield RegisterSuccess();
        yield RegisterInitial();
      } else {
        yield RegisterFailure(error: 'Something very weird just happened');
      }
    } catch (e) {
      yield RegisterFailure(error: e.message);
    }
  }
}
