import 'package:flutter/material.dart';

import '../utils/utils.dart';

double get appPaddingHori => 20.sw;

extension ScaleExt on num {
  double get _s => scaleW(appContext);

  double get s => this * _s;
  double get sw2 => this * (_s < .2 ? .2 : _s);
  double get sw3 => this * (_s < .3 ? .3 : _s);
  double get sw4 => this * (_s < .4 ? .4 : _s);
  double get sw5 => this * (_s < .5 ? .5 : _s);
  double get sw6 => this * (_s < .6 ? .6 : _s);
  double get sw7 => this * (_s < .7 ? .7 : _s);
  double get sw8 => this * (_s < .8 ? .8 : _s);
  double get sw9 => this * (_s < .9 ? .9 : _s);

  double get sw => this * (_s < .65 ? .65 : _s);
}

double scaleW(context, [double v = 1]) {
  if (MediaQuery.sizeOf(context).width >= 1280) return 1;
  return MediaQuery.sizeOf(context).width / 1280 * v;
}

double fs44([context]) => 44.0;

double fs36([context]) => 36.0;

double fs32([context]) => 32.0;

double fs28([context]) => 28.0;

double fs24([context]) => 24.0;

double fs20([context]) => 20.0;

double fs18([context]) => 18.0;

double fs16([context]) => 16.0;

double fs14([context]) => 14.0;

double fs12([context]) => 12.0;

double fs10([context]) => 10.0;

double fs8([context]) => 8.0;
