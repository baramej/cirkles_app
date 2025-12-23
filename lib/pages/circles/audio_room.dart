import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/circles/audio_room_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_client/livekit_client.dart';

class AudioRoomParams {
  final String name;
  final String accessToken;

  AudioRoomParams({required this.name, required this.accessToken});
}

class AudioRoom extends StatefulWidget {
  const AudioRoom({
    super.key,
    required this.params,
  });

  final AudioRoomParams params;

  @override
  State<AudioRoom> createState() => AudioRoomController();
}

class AudioRoomController extends State<AudioRoom> {
  bool loading = true;
  bool isMuted = false;
  String? error;
  Room room = Room(
    roomOptions: const RoomOptions(
      adaptiveStream: true,
      dynacast: true,
    ),
  );

  void toggleIsMuted() {
    if (room.localParticipant != null) {
      setState(() {
        isMuted = !isMuted;
        room.localParticipant!.setMicrophoneEnabled(!isMuted);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await room.connect(AppConfig.livekitServerUrl, widget.params.accessToken);
        room.localParticipant?.setMicrophoneEnabled(true);
        setState(() {
          loading = false;
        });
      } catch (e) {
        setState(() {
          error = e.toString();
          loading = false;
        });
      }
    });
  }

  Future<void> leaveRoom() async {
    setState(() {
      loading = true;
    });
    try {
      await room.disconnect();
      context.pop();
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AudioRoomView(this);
  }

  @override
  void dispose() {
    room.disconnect();
    super.dispose();
  }
}
