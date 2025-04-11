import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/products_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
    path: '/produtos',
    builder: (context, state) => const ProductsScreen(),
    ),

  ],
  redirect: (context, state) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final isLoggedIn = auth.isLoggedIn;

    final goingToLogin = state.subloc == '/login' || state.subloc == '/register';

    if (!isLoggedIn && !goingToLogin) return '/login';
    if (isLoggedIn && goingToLogin) return '/home';

    return null;
  },
  refreshListenable: GoRouterRefreshStream(
    Provider.of<AuthProvider>(navigatorKey.currentContext!, listen: false).stream,
  ),
);

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
