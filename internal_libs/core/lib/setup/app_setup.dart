import 'package:flutter/material.dart';

import 'app_base.dart';

AppSetup? get appSetup => AppSetup._instance;
AppColorsBase? get appColors => appSetup?.appColors;
AppPrefsBase? get appPrefs => appSetup?.appPrefs;

Color get appColorPrimary => appSetup?.appColors.primary ?? Colors.white;
Color get appColorBackground => appSetup?.appColors.background ?? Colors.white;
Color get appColorElement => appSetup?.appColors.element ?? Colors.white;
Color get appColorText => appSetup?.appColors.text ?? Colors.white;

BuildContext? get findAppContext => appSetup?.findAppContext?.call();

class AppSetup {
  static AppSetup? _instance;
  static initialized({required AppSetup value}) {
    _instance = value;
  }

  AppEnv env;
  AppPrefsBase appPrefs;
  AppColorsBase appColors;
  AppTextStyleWrap? appTextStyleWrap;
  BuildContext? Function()? findAppContext;

  PNetworkOptions? networkOptions;

  AppSetup({
    required this.env,
    required this.appPrefs,
    required this.appColors,
    this.appTextStyleWrap,
    this.findAppContext,
    this.networkOptions,
  });

  AppSetup copyWith({
    AppEnv? env,
    AppPrefsBase? appPrefs,
    AppColorsBase? appColors,
    AppTextStyleWrap? appTextStyleWrap,
    BuildContext? Function()? findAppContext,
    PNetworkOptions? networkOptions,
  }) {
    return AppSetup(
      env: env ?? this.env,
      appPrefs: appPrefs ?? this.appPrefs,
      appColors: appColors ?? this.appColors,
      appTextStyleWrap: appTextStyleWrap ?? this.appTextStyleWrap,
      findAppContext: findAppContext ?? this.findAppContext,
      networkOptions: networkOptions ?? this.networkOptions,
    );
  }
}
