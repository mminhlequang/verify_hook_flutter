import 'package:internal_core/setup/app_base.dart';
import 'package:internal_core/setup/app_setup.dart';
import 'package:google_fonts/google_fonts.dart';

import 'src/constants/constants.dart';
import 'src/utils/utils.dart';

internalSetup() {
  AppSetup.initialized(
    value: AppSetup(
      env: AppEnv.preprod,
      appColors: AppColors.instance,
      appPrefs: AppPrefs.instance,
      appTextStyleWrap: AppTextStyleWrap(
        fontWrap: (textStyle) => GoogleFonts.roboto(textStyle: textStyle),
      ),
    ),
  );
}