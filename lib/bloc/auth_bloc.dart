import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      if (event.username.isNotEmpty && event.password.isNotEmpty) {
        emit(AuthSuccess());
      } else {
        emit(const AuthFailure('Username and password cannot be empty'));
      }
    });
  }
}