import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/otp_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const verify = '/verify';
  static const dashboard = '/dashboard';
}

GoRouter buildAppRouter({required bool isAuthenticated}) => GoRouter(
      initialLocation:
          isAuthenticated ? AppRoutes.dashboard : AppRoutes.login,
      routes: [
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.verify,
          builder: (context, state) => const OtpScreen(),
        ),
        GoRoute(
          path: AppRoutes.dashboard,
          builder: (context, state) => const DashboardScreen(),
        ),
      ],
    );