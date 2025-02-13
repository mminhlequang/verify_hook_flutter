import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';

import '../presentation/usdt_tron/usdt_tron_screen.dart';
import 'app_get.dart';

GlobalKey<NavigatorState> get appNavigatorKey =>
    findInstance<GlobalKey<NavigatorState>>();
bool get isAppContextReady => appNavigatorKey.currentContext != null;
BuildContext get appContext => appNavigatorKey.currentContext!;
final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

pushWidget({
  required child,
  String? routeName,
  bool opaque = true,
}) {
  return Navigator.of(appContext).push(PageRouteBuilder(
    opaque: opaque,
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
    settings: RouteSettings(name: routeName),
  ));
}

// GoRouter configuration
final goRouter = GoRouter(
  initialLocation: '/usdt_tron/adsspeed',
  navigatorKey: appNavigatorKey,
  routes: [
    GoRoute(
      path: '/usdt_tron/:platform',
      builder: (context, state) => Title(
        title: 'TRON USDT',
        color: appColorPrimary,
        child: UsdtTronScreen(
          platformId: state.pathParameters['platform'] ?? '',
          message: state.uri.queryParameters['message'] ?? '',
        ),
      ),
    ),
  ],
);
