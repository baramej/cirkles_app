import 'dart:convert';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/moments/moments_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class Moments extends StatefulWidget {
  const Moments({super.key});

  @override
  State<Moments> createState() => MomentsController();
}

class MomentsController extends State<Moments> {
  bool loading = true;
  String? error;
  List<Map<String, dynamic>> stations = [];
  AudioPlayer player = AudioPlayer();

  Future<void> loadStations() async {
    final l10n = L10n.of(context);
    final url = Uri.parse('${AppConfig.azuraCastServerUrl}/api/stations');
    final headers = {'accept': 'application/json'};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
        stations = (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
      });
    } else {
      setState(() {
        loading = false;
        error = l10n.momentsError;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadStations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MomentsView(
      controller: this,
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
