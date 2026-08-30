import 'package:auto_route/auto_route.dart';
import 'package:client_app_example/core/navigation/route_guards.dart';
import 'package:client_app_example/features/auth/presentation/pages/login_page.dart';
import 'package:client_app_example/features/posts/presentation/pages/posts_demo_page.dart';
import 'package:injectable/injectable.dart';

part 'app_router.gr.dart';

/// The app router.
@singleton
// replaceInRouteName is used to replace the Page,Route suffix with
// the actual name of the route.
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: PostsDemoRoute.page,
      path: '/',
      initial: true,
      guards: const [AuthGuard()],
    ),
    AutoRoute(
      page: LoginRoute.page,
      path: '/login',
      guards: const [AuthGuard(requiresAuth: false)],
    ),
  ];
}
