import 'package:go_router/go_router.dart';
import 'package:musuem_guide_app_ui/presentation/screens/detail_screen.dart';
import 'package:musuem_guide_app_ui/presentation/screens/home_screen.dart';
import 'package:musuem_guide_app_ui/presentation/screens/scanning_screen.dart';

GoRouter router = GoRouter(
  initialLocation: NamedRoutes.home.routeName,
  routes: [
    GoRoute(path: NamedRoutes.home.routeName, builder: (ctx, state) => const HomeScreen(),),
    GoRoute(path: NamedRoutes.scanning.routeName, builder: (ctx, state) => const ScanningScreen(),),
    GoRoute(
      path: NamedRoutes.detail.routeName,
      builder: (ctx, state) => DetailScreen(exhibitId: state.pathParameters['id'] ?? '',),
    ),
  ],
);

enum NamedRoutes {
  home('/home'),
  scanning('/scanning'),
  detail('/detail/:id');

  final String routeName;
  const NamedRoutes(this.routeName);

  static String detailPath(String id) => '/detail/$id';
}
