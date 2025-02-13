import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:go_router/go_router.dart';
import 'package:app/firebase_options.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_portal/flutter_portal.dart';

import 'internal_setup.dart';
import 'src/base/bloc.dart';
import 'src/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    AppPrefs.instance.initialize(),
    initEasyLocalization(),
  ]);
  bloc.Bloc.observer = AppBlocObserver();

  internalSetup();
  getItSetup();

  runApp(wrapEasyLocalization(child: const _App()));
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MaterialApp.router(
        routerConfig: goRouter,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: AppPrefs.instance.isDarkTheme
            ? ThemeData.dark()
            : ThemeData.light().copyWith(
                textSelectionTheme:
                    TextSelectionThemeData(selectionColor: Colors.blueAccent.withOpacity(0.5))),
        themeMode: AppPrefs.instance.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}