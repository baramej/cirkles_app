import 'dart:convert';

import 'package:fluffychat/pages/circles/rooms_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Rooms extends StatefulWidget {
  const Rooms({super.key});

  @override
  State<Rooms> createState() => RoomsController();
}

class RoomsController extends State<Rooms> {
  bool loading = true;
  String? error;
  String? accessToken;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAccessToken();
    });
  }

  Future<void> getAccessToken() async {
    final client = Matrix.of(context).client;
    final username = client.userID?.localpart;
    final response = await http.post(
      Uri.parse("https://livekitapi.cirkles.app/api/v1/getToken"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "room": "publicRoom",
        "username": username ?? "user-${DateTime.now().millisecondsSinceEpoch}",
      }),
    );

    if (response.statusCode == 200) {
      await Permission.microphone.request();
      setState(() {
        loading = false;
        accessToken = response.body;
      });
    } else {
      setState(() {
        loading = false;
        error = response.body;
      });
    }
  }

  Future<void> joinRoom() async {
    if (accessToken == null) {
      return;
    }

    context.push(
      '${GoRouter.of(context).routeInformationProvider.value.uri.path}/room',
      extra: accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => this,
      child: RoomsView(this),
    );
  }
}
