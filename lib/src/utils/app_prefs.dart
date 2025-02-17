import 'dart:io';
import 'dart:convert';

import 'package:internal_core/setup/app_base.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:path_provider/path_provider.dart';

class AppPrefs extends AppPrefsBase {
  AppPrefs._();

  static final AppPrefs _instance = AppPrefs._();

  static AppPrefs get instance => _instance;

  late Box _boxData;
  late Box _boxAuth;
  bool _initialized = false;

  Future initialize() async {
    if (_initialized) return;
    if (!kIsWeb) {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      Hive.init(appDocDirectory.path);
    }
    _boxData = await Hive.openBox('data');
    _boxAuth = await Hive.openBox(
      'auth',
      encryptionCipher: HiveAesCipher(base64Url.decode(
        const String.fromEnvironment(
          'SECRET_KEY',
          defaultValue: 'jgGYXtQC6hIAROYyI_bbBZu4jFVHiqUICSf8yN2zp_8=',
        ),
      )),
    );
    _initialized = true;
  }

  Stream watch(key) => _boxData.watch(key: key);

  void clear() {
    _boxData.deleteAll([
      AppPrefsBase.accessTokenKey,
      AppPrefsBase.refreshTokenKey,
      AppPrefsBase.themeModeKey,
      AppPrefsBase.languageCodeKey,
      "user_info",
    ]);
  }

  bool get isDarkTheme =>
      AppPrefs.instance.themeModel == AppPrefsBase.themeModeDarkKey;

  set themeModel(String? value) =>
      _boxData.put(AppPrefsBase.themeModeKey, value);

  String? get themeModel =>
      _boxData.get(AppPrefsBase.themeModeKey) ?? AppPrefsBase.themeModeDarkKey;

  @override
  set languageCode(String? value) =>
      _boxData.put(AppPrefsBase.languageCodeKey, value);

  @override
  String get languageCode => _boxData.get(AppPrefsBase.languageCodeKey) ?? 'en';

  @override
  set dateFormat(String value) => _boxData.put('dateFormat', value);

  @override
  String get dateFormat => _boxData.get('dateFormat') ?? 'en';

  @override
  set timeFormat(String value) => _boxData.put('timeFormat', value);

  @override
  String get timeFormat => _boxData.get('timeFormat') ?? 'en';

  // Future saveAccountToken(AccountToken token) async {
  //   await Future.wait([
  //     _box.put(AppPrefsBase.accessTokenKey, token.accessToken),
  //     _box.put(AppPrefsBase.refreshTokenKey, token.refreshToken)
  //   ]);
  // }

  // dynamic getNormalToken() async {
  //   var result = await _box.get(AppPrefsBase.accessTokenKey);
  //   if (result != null) {
  //     DateTime? expiryDate = Jwt.getExpiryDate(result.toString());
  //     if (expiryDate != null &&
  //         expiryDate.millisecondsSinceEpoch <
  //             DateTime.now().millisecondsSinceEpoch) {
  //       String? refresh = await _box.get(AppPrefsBase.refreshTokenKey);
  //       if (refresh != null) {
  //         NetworkResponse response =
  //             await AccountUsersRepo().refresh_access_token(refresh);
  //         if (response.data?.accessToken != null) {
  //           result = response.data?.accessToken;
  //           saveAccountToken(response.data!);
  //         }
  //       }
  //     }
  //   }
  //   return result;
  // }

  // AccountUser? get user {
  //   final objectString = _box.get('user_info');
  //   if (objectString != null) {
  //     final jsonMap = jsonDecode(objectString);
  //     return AccountUser.fromJson(jsonMap);
  //   }
  //   return null;
  // }

  // set user(userInfo) {
  //   if (userInfo != null) {
  //     final string = json.encode(userInfo.toJson());
  //     _box.put('user_info', string);
  //   } else {
  //     _box.delete('user_info');
  //   }
  // }
}
