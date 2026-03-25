import 'dart:convert';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/circles/rooms_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Rooms extends StatefulWidget {
  const Rooms({super.key});

  @override
  State<Rooms> createState() => RoomsController();
}

class RoomsController extends State<Rooms> {
  bool loading = true;
  String? error;
  List<Map<String, dynamic>> circles = [];
  List<Map<String, dynamic>> myCircles = [];

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => this,
      child: RoomsView(this),
    );
  }

  Future<void> deleteCircle(int id) async {
    final l10n = L10n.of(context);

    setState(() {
      loading = true;
    });

    try {
      await Supabase.instance.client.from('circle').delete().eq('id', id);
      getCircles();
    } catch (err) {
      setState(() {
        loading = false;
        error = l10n.circlesError;
      });
    }
  }

  Future<void> getAccessToken(String name) async {
    final client = Matrix.of(context).client;
    final username = client.userID?.localpart;
    final response = await http.post(
      Uri.parse(AppConfig.livekitTokenServerUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "room": name,
        "username": username ?? "user-${DateTime.now().millisecondsSinceEpoch}",
      }),
    );

    if (response.statusCode == 200) {
      await Permission.microphone.request();
      setState(() {
        loading = false;
        context.push(
          '${GoRouter.of(context).routeInformationProvider.value.uri.path}/room',
          extra: <String, dynamic>{
            "name": name,
            "accessToken": response.body,
          },
        );
      });
    } else {
      setState(() {
        loading = false;
        error = response.body;
      });
    }
  }

  Future<void> getCircles() async {
    final username = Matrix.of(context).client.userID?.localpart;
    final response = await Supabase.instance.client.from('circle').select();
    setState(() {
      loading = false;
      error = null;
      circles = response.where((c) => c['username'] != username).toList()
        ..sort((a, b) {
          if (a['username'] == null && b['username'] != null) return -1;
          if (a['username'] != null && b['username'] == null) return 1;
          return 0;
        });
      myCircles = response.where((c) => c['username'] == username).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCircles();
    });
  }

  Future<void> onPressedNewCircle() async {
    final result = await context.push<bool?>(
      '${GoRouter.of(context).routeInformationProvider.value.uri.path}/newcircle',
    );

    if (result == true) {
      setState(() {
        loading = true;
      });
      getCircles();
    }
  }

  Future<void> refresh() async {
    setState(() {
      loading = true;
      error = null;
    });

    getCircles();
  }
}
