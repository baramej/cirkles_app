import 'dart:convert';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/moments/moments_view.dart';
import 'package:fluffychat/pages/moments/station_tile.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:visibility_detector/visibility_detector.dart';

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

  StationCardController? _stationCardController;

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
    return VisibilityDetector(
      key: const Key('moments-key'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0) {
          final matrix = Matrix.of(context);
          ScaffoldMessenger.of(matrix.context).showMaterialBanner(
            MaterialBanner(
              padding: EdgeInsets.zero,
              leading: StreamBuilder(
                stream: player.playerStateStream.asBroadcastStream(),
                builder: (context, _) => IconButton(
                  onPressed: () {
                    if (player.isAtEndPosition) {
                      player.seek(Duration.zero);
                    } else if (player.playing) {
                      player.pause();
                    } else {
                      player.play();
                    }
                  },
                  icon: player.playing && !player.isAtEndPosition
                      ? const Icon(Icons.pause_outlined)
                      : const Icon(Icons.play_arrow_outlined),
                ),
              ),
              content: Text(
                _stationCardController?.widget.station['name'] ?? L10n.of(context).live,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _stationCardController?.toggle();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(matrix.context).clearMaterialBanners();
                    });
                  },
                  icon: const Icon(Icons.close_outlined),
                ),
              ],
            ),
          );
        }
      },
      child: MomentsView(
        controller: this,
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void setStationCardController(StationCardController controller) {
    _stationCardController = controller;
  }
}

extension on AudioPlayer {
  bool get isAtEndPosition {
    final duration = this.duration;
    if (duration == null) return true;
    return position >= duration;
  }
}
