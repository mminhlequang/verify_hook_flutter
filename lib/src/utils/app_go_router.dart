import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../presentation/dashboard/cubit/dashboard_cubit.dart';
import '../presentation/dashboard/dashboard_screen.dart';
import '../presentation/home/cubit/home_cubit.dart';

import '../presentation/home/home_screen.dart';
import '../presentation/verify_portal/verify_portal_screen.dart';
import 'app_get.dart';

GlobalKey<NavigatorState> get appNavigatorKey =>
    findInstance<GlobalKey<NavigatorState>>();
bool get isAppContextReady => appNavigatorKey.currentContext != null;
BuildContext get appContext => appNavigatorKey.currentContext!;

// GoRouter configuration
final goRouter = GoRouter(
  initialLocation:
      '/verify_portal?platformId=123&identifierCode=456&networkCode=TRX',
  navigatorKey: appNavigatorKey,
  routes: [
    GoRoute(
      name: '/',
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (context) => HomeCubit(),
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      name: '/verify_portal',
      path:
          '/verify_portal', //verify_portal?platformId=123&identifierCode=456&networkCode=TRX
      builder: (context, state) => VerifyPortalScreen(
        platformId: state.uri.queryParameters['platformId'],
        identifierCode: state.uri.queryParameters['identifierCode'],
        networkCode: state.uri.queryParameters['networkCode'],
      ),
    ),
    GoRoute(
      name: '/dashboard',
      path: '/dashboard',
      builder: (context, state) => BlocProvider(
        create: (context) => DashboardCubit(),
        child: const DashboardScreen(),
      ),
      routes: [
        // GoRoute(
        //   name: '/auth',
        //   path: '/auth',
        //   builder: (context, state) => const AuthScreen(),
        // ),
        // GoRoute(
        //   path: '/transactions',
        //   builder: (context, state) => const TransactionsScreen(),
        // ),
        // GoRoute(
        //   name: '/setup_profile',
        //   path: '/setup_profile',
        //   builder: (context, state) => const SetupProfileScreen(),
        // ),
        // GoRoute(
        //   name: '/setup_webhook',
        //   path: '/setup_webhook',
        //   builder: (context, state) => const SetupWebhookScreen(),
        // ),
      ],
    ),
  ],
);
