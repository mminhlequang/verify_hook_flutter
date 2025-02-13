import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';

enum AppStatus {
  all,
  disable,
  needPay,
  active,
  closed,
  grace,
  restricted,
  unknown;

  String get displayName => switch (this) {
        all => 'All'.tr(),
        disable => 'Disable'.tr(),
        needPay => 'Need Pay'.tr(),
        active => 'Active'.tr(),
        closed => 'Closed'.tr(),
        grace => 'Grace'.tr(),
        restricted => 'Restricted'.tr(),
        unknown => 'Unknown'.tr(),
      };

  Color get color => switch (this) {
        all => Colors.black,
        disable => Colors.red,
        needPay => Colors.orangeAccent,
        active => hexColor('#28CA6E'),
        closed => Colors.black.withOpacity(.6),
        grace => Colors.blue,
        restricted => Colors.red,
        unknown => hexColor('#D9D9D9'),
      };
}
