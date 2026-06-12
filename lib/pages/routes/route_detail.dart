import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/routes/route_detail_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RouteDetail extends StatefulWidget {
  const RouteDetail({
    super.key,
    required this.routeId,
  });

  final int routeId;

  @override
  State<RouteDetail> createState() => RouteDetailController();
}

class RouteDetailController extends State<RouteDetail> {
  Map<String, dynamic>? route;
  List<Map<String, dynamic>> experiences = [];
  bool loading = true;
  String? error;
  bool canDelete = false;

  Future<void> initData() async {
    final l10n = L10n.of(context);

    final routes =
        await Supabase.instance.client.from('route').select('*, category_id(id, name)').eq('id', widget.routeId);

    final response = await Supabase.instance.client
        .from('route_route_experience')
        .select('*, experience_id(id, name, name_ar, icon)')
        .eq('route_id', widget.routeId);

    if (routes.isNotEmpty) {
      var allowDeleteAction = false;
      final username = Matrix.of(context).client.userID?.localpart;

      if (username != null) {
        allowDeleteAction = routes.first["username"] == username;
      }

      setState(() {
        loading = false;
        route = routes.first;
        experiences = response;
        canDelete = allowDeleteAction;
      });
    } else {
      setState(() {
        loading = false;
        error = l10n.routeDetailError;
      });
    }
  }

  Future<void> deleteRoute() async {
    if (route?['id'] == null) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    setState(() {
      loading = true;
    });

    try {
      await Supabase.instance.client.rpc('delete_route', params: {'p_route_id': route!['id']});
      context.pop(true);
    } on PostgrestException catch (_) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(L10n.of(context).routeDeleteError)),
      );

      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  Future<void> openNavigation() async {
    final url = Uri.parse(route!['url']);
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RouteDetailView(controller: this);
  }
}
