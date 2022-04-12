import 'package:flutter/material.dart';
import 'package:gloc_ui/widgets/DetailsPage.dart';
import 'package:gloc_ui/widgets/HomePage.dart';
import 'package:gloc_ui/widgets/LoadingPage.dart';
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
      );

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
          ]),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(child: Text(state.error.toString())),
        )),
  );
}
