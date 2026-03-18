import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/routes/route_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RouteExperienceIcon {
  static IconData toIconData(String name) {
    switch (name) {
      case 'wifi':
        return Icons.wifi;
      case 'parking':
        return Icons.local_parking;
      case 'restaurant':
        return Icons.restaurant;
      case 'gas':
        return Icons.local_gas_station;
      default:
        return Icons.info;
    }
  }
}

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

  Future<void> initData() async {
    final l10n = L10n.of(context);

    final routes =
        await Supabase.instance.client.from('route').select('*, category_id(id, name)').eq('id', widget.routeId);

    final response = await Supabase.instance.client
        .from('route_route_experience')
        .select('*, experience_id(id, name, name_ar, icon)')
        .eq('route_id', widget.routeId);

    if (routes.isNotEmpty) {
      setState(() {
        loading = false;
        route = routes.first;
        experiences = response;
      });
    } else {
      setState(() {
        loading = false;
        error = l10n.routeDetailError;
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
