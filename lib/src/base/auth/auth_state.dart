part of 'auth_cubit.dart';

class AuthState {
  AuthStateType stateType;
  dynamic user;

  AuthState({
    this.stateType = AuthStateType.none,
    this.user,
  });

  AuthState update({AuthStateType? stateType, dynamic user}) {
    return AuthState(
      stateType: stateType ?? this.stateType,
      user: user ?? this.user,
    );
  }
}
