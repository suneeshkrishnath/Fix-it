import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/otp_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/dashboard/presentation/feature_placeholder_screen.dart';
import '../features/requests/domain/models/service_request.dart';
import '../features/requests/presentation/screens/create_service_request_screen.dart';
import '../features/requests/presentation/screens/my_requests_screen.dart';
import '../features/requests/presentation/screens/request_details_screen.dart';
import '../features/requests/presentation/screens/service_history_screen.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const verify = '/verify';
  static const dashboard = '/dashboard';
  static const createRequest = '/requests/new';
  static const requestSubmitted = '/requests/submitted';
  static const requests = '/requests';
  static String requestDetails(String requestId) => '/requests/$requestId';
  static const history = '/history';
  static const moveOut = '/move-out';
  static const profile = '/profile';
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
        GoRoute(
          path: AppRoutes.createRequest,
          builder: (context, state) => const CreateServiceRequestScreen(),
        ),
        GoRoute(
          path: AppRoutes.requestSubmitted,
          builder: (context, state) => RequestSubmittedScreen(
            request: state.extra! as ServiceRequest,
          ),
        ),
        GoRoute(
          path: AppRoutes.requests,
          builder: (context, state) => const MyRequestsScreen(),
        ),
        GoRoute(
          path: '/requests/:requestId',
          builder: (context, state) => RequestDetailsScreen(
            requestId: state.pathParameters['requestId']!,
          ),
        ),
        GoRoute(
          path: AppRoutes.history,
          builder: (context, state) => const ServiceHistoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.moveOut,
          builder: (context, state) => const FeaturePlaceholderScreen(
            title: 'Move-out request',
            description: 'Move-out requests are planned for a later stage.',
          ),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const FeaturePlaceholderScreen(
            title: 'Resident profile',
            description: 'Resident profile details are planned for a later stage.',
          ),
        ),
      ],
    );