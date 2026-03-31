import 'dart:async';

import 'package:fluffychat/pages/moments/album_art_image.dart';
import 'package:fluffychat/pages/moments/live_chip_animated.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

typedef StationCardSetter = void Function(StationCardController controller);

class StationCard extends StatefulWidget {
  final Map<String, dynamic> station;
  final AudioPlayer player;
  final StationCardSetter setStationCardController;
  const StationCard({
    super.key,
    required this.station,
    required this.player,
    required this.setStationCardController,
  });

  @override
  State<StationCard> createState() => StationCardController();
}

class StationCardController extends State<StationCard> {
  bool isPlaying = false;
  StreamSubscription<SequenceState>? _subscription;

  String get streamUrl {
    if (widget.station['hls_enabled'] == true && widget.station['hls_url'] != null) {
      return widget.station['hls_url'];
    }
    return widget.station['listen_url'];
  }

  Future<void> toggle() async {
    if (isPlaying) {
      setState(() => isPlaying = false);
      await widget.player.stop();
    } else {
      setState(() => isPlaying = true);
      await widget.player.setAudioSource(
        AudioSource.uri(
          Uri.parse(streamUrl),
          tag: widget.station['id'],
        ),
      );
      await widget.player.play();
    }
  }

  @override
  void initState() {
    super.initState();
    _subscription = widget.player.sequenceStateStream.listen((state) {
      if (mounted) {
        final tag = state.currentSource?.tag;
        if (tag != widget.station['id']) {
          setState(() {
            isPlaying = false;
          });
        } else {
          widget.setStationCardController(this);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = widget.station;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          AlbumArtWidget(stationId: s['id']),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  s['shortcode'],
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: toggle,
              ),
              if (isPlaying)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: LiveChipAnimated(),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
