// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/ProductsScreen.dart';
import '../screens/SubscriptionScreen.dart';
import '../screens/points_screen.dart';
import '../screens/collection_points_screen.dart';
import '../screens/farmer_report_screen.dart';
import '../screens/farmer_product_create_screen.dart';
import '../screens/farmer_products_screen.dart';
import '../screens/ProfileScreen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/produtos',
      builder: (context, state) => const ProductsScreen(),
    ),
    GoRoute(
      path: '/assinatura',
      builder: (context, state) => const SubscriptionScreen(),
    ),
    GoRoute(
      path: '/pontos',
      builder: (context, state) => const CollectionPointsScreen(),
    ),
    GoRoute(
      path: '/agricultor',
      builder: (_, __) => const FarmerProductsScreen(),
    ),
    GoRoute(
      path: '/agricultor/novo',
      builder: (_, __) => const FarmerProductCreateScreen(),
    ),
    GoRoute(
      path: '/agricultor/relatorio',
      builder: (_, __) => const FarmerReportScreen(),
    ),
    GoRoute(path: '/perfil', builder: (_, __) => const ProfileScreen()),
  ],
  redirect: (context, state) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final isLoggedIn = auth.isLoggedIn;

    final goingToLogin =
        state.fullPath == '/login' || state.fullPath == '/register';

    if (!isLoggedIn && !goingToLogin) return '/login';
    if (isLoggedIn && goingToLogin) return '/home';

    return null;
  },
  refreshListenable: Provider.of<AuthProvider>(
    navigatorKey.currentContext!,
    listen: false,
  ),
);

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
