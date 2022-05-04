import 'package:flutter/material.dart';
import 'package:gloc_ui/pages/DetailsPage.dart';
import 'package:gloc_ui/pages/HistoryPage.dart';
import 'package:gloc_ui/pages/HomePage.dart';
import 'package:gloc_ui/pages/LoadingPage.dart';
import 'package:go_router/go_router.dart';

import 'data/ClocRequest.dart';
import 'data/ClocResult.dart';

void main() {
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      theme: ThemeData(
          primaryColor: Color(0xff6750A4),
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontFamily: 'IBMPlexMono'),
            displayMedium: TextStyle(fontFamily: 'IBMPlexMono'),
            displaySmall: TextStyle(fontFamily: 'IBMPlexMono'),
            titleLarge: TextStyle(fontFamily: 'IBMPlexMono'),
            titleMedium: TextStyle(fontFamily: 'IBMPlexMono'),
            titleSmall: TextStyle(fontFamily: 'IBMPlexMono'),
            labelLarge: TextStyle(fontFamily: 'IBMPlexMono'),
            labelMedium: TextStyle(fontFamily: 'IBMPlexMono'),
            labelSmall: TextStyle(fontFamily: 'IBMPlexMono'),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(primary: Color(0xff6750A4)))));

  final _router = GoRouter(
    initialLocation: '/',
    routes: <GoRoute>[
      GoRoute(
          name: 'home',
          path: '/',
          builder: (context, state) => HomePage(key: state.pageKey),
          routes: [
            GoRoute(
                name: 'loading',
                path: 'loading',
                redirect: (state) => (state.extra == null) ? '/' : null,
                builder: (context, state) => LoadingPage(
                      key: state.pageKey,
                      request: state.extra! as ClocRequest,
                    )),
            GoRoute(
                name: 'details',
                path: 'details',
                redirect: (state) => (state.extra == null) ? '/' : null,
                builder: (context, state) => DetailsPage(
                    key: state.pageKey,
                    clocResult: state.extra! as ClocResult)),
            GoRoute(
                name: 'history',
                path: 'history',
                redirect: (state) => (state.extra == null) ? '/' : null,
                builder: (context, state) => HistoryPage(
                    key: state.pageKey,
                    historyResult: state.extra! as List<ClocResult>)),
          ]),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(child: Text(state.error.toString())),
        )),
  );
}
