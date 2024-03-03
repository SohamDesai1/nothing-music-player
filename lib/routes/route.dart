import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:n_music_player/screens/home.dart';

class Routes {
  static GoRouter router = GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
    routes: [
      GoRoute(
        path: '/',
        name: "Home",
        builder: (ctx, st) => const Home(),
      ),
    ],
  );
}
