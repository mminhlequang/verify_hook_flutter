import 'package:internal_core/internal_core.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class AppColors extends AppColorsBase {
  AppColors._();

  static final AppColors _instance = AppColors._();

  static AppColors get instance => _instance;

  @override
  Color get text => byTheme(Colors.black, kdark: Colors.white);

  @override
  Color get background => byTheme(Colors.white, kdark: Colors.black);

  @override
  Color get element => byTheme(Colors.grey[200]!, kdark: hexColor('#161618'));

  @override
  Color get primary => byTheme(hexColor('3682C8'));

  @override
  Color get shimerHighlightColor => byTheme(hexColor('1E1C58'));

  @override
  Color get shimmerBaseColor => byTheme(hexColor('3682C8'));
}

byTheme(klight, {kdark}) {
  if (AppPrefs.instance.isDarkTheme) {
    return kdark ?? klight;
  }
  return klight;
}
