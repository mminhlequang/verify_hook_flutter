import 'dart:async';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/firestore_resources/firestore_resources.dart';
import 'package:bloc/bloc.dart';
import 'package:app/src/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

part 'auth_state.dart';

enum AuthStateType { none, logged }

AuthCubit get authCubit => findInstance<AuthCubit>();

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  bool get isLoggedIn => state.stateType == AuthStateType.logged;

  bool get isAdmin => state.user[kdbrole] == roleAdmin;
  bool get isUser => state.user[kdbrole] == roleUser;
  bool get isGuest => state.user[kdbrole] == roleGuest;

  String get firebaseId => state.user[kdbfirebaseId];

  update(user) async {
    state.user = user;
    emit(state.update());
    // if (state.user == null) {
    //   add(LogoutAuthEvent());
    // }
  }

  load({Duration delayRedirect = const Duration(seconds: 1)}) async {
    //Check admin account if not exist then create
    if (kDebugMode) {
      var query = await colAdmins.where(kdbrole, isEqualTo: roleAdmin).get();
      if (query.docs.isEmpty) {
        final userCredential =
            await registerWithEmailAndPassword(adminEmail, adminPassword);
        var id = userCredential.user!.uid;
        Map<String, dynamic> data = {
          kdbfirebaseId: id,
          kdbrole: roleAdmin,
          kdbfullname: "Admin",
          kdbphonenumber: "0979629201",
          kdbemail: adminEmail,
          kdbisEnable: true,
        };
        await colAdmins.doc(id).set(data);
      }
    }

    try {
      final isLoggedIn = await checkUserLoggedIn();
      if (isLoggedIn) {
        var query = await colAdmins.doc(currentUser.uid).get();
        if (query.exists) {
          state.user = query.data()!;
          emit(state.update(stateType: AuthStateType.logged));
          return;
        }
      }
    } catch (e) {
      appTopRightNotification(context: appContext, message: e.toString());
    }
    emit(state.update(stateType: AuthStateType.none));

    await Future.delayed(delayRedirect);
    _redirect();
  }

  logout() async {
    try {
      emit(state.update(stateType: AuthStateType.none));
      _redirect();
    } catch (_) {}
  }

  _redirect() {
    if (state.stateType != AuthStateType.logged) {
      appContext.pushReplacement('/login');
    } else {
      appContext.pushReplacement('/home');
    }
  }
}
