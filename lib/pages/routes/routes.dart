import 'package:collection/collection.dart';
import 'package:fluffychat/pages/routes/routes_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => RoutesController();
}

class RoutesController extends State<Routes> {
  bool loading = true;
  String? error;
  List<Map<String, dynamic>> allRoutes = [];
  List<Map<String, dynamic>> routes = [];
  List<Map<String, dynamic>> categories = [];
  Map<String, dynamic>? selectedCategory;
  bool hasOwnRoute = true;

  @override
  Widget build(BuildContext context) {
    return RoutesView(controller: this);
  }

  Future<void> initData() async {
    await Future.wait([
      loadRoutes(),
      loadCategories(),
    ]);

    setState(() {
      loading = false;
      error = null;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  Future<void> loadCategories() async {
    final response = await Supabase.instance.client.from('route_category').select();
    setState(() {
      selectedCategory = {
        "id": 0,
        "created_at": DateTime.now().toIso8601String(),
        "name": "All",
        "name_ar": "الجميع",
      };

      categories = <Map<String, dynamic>>[
        selectedCategory!,
        ...response,
      ];
    });
  }

  Future<void> loadRoutes() async {
    final username = Matrix.of(context).client.userID?.localpart;
    final response = await Supabase.instance.client.from('route').select('*, category_id(id, name)');
    setState(() {
      routes = response.toList();
      allRoutes = response.toList();
      hasOwnRoute = response.firstWhereOrNull((r) => r['username'] == username) != null;
    });
  }

  Future<void> navigateToNewRoute() async {
    final result = await context.push<bool>(
      '${GoRouter.of(context).routeInformationProvider.value.uri.path}/newroute',
    );

    if (result == true) {
      setState(() {
        loading = true;
      });

      await loadRoutes();

      setState(() {
        loading = false;
      });
    }
  }

  void navigateToRouteDetail(int id) {
    context.push(
      '${GoRouter.of(context).routeInformationProvider.value.uri.path}/$id',
    );
  }

  Future<void> refresh() async {
    setState(() {
      loading = true;
      error = null;
    });

    await loadRoutes();

    setState(() {
      loading = false;
      error = null;
    });
  }

  void setSelectedCategory(Map<String, dynamic> value) {
    setState(() {
      selectedCategory = value;
      if (value['id'] == 0) {
        routes = allRoutes.toList();
      } else {
        routes = allRoutes.where((e) => e['category_id']['id'] == value['id']).toList();
      }
    });
  }

  void sortRoutesByLongest() {
    setState(() {
      routes.sort((a, b) => a['duration'] < b['duration'] ? 1 : -1);
    });
  }

  void sortRoutesByShortest() {
    setState(() {
      routes.sort((a, b) => a['duration'] < b['duration'] ? -1 : 1);
    });
  }
}
