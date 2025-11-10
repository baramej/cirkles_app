import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/circles/audio_room.dart';
import 'package:flutter/material.dart';

class AudioRoomView extends StatelessWidget {
  const AudioRoomView(this.controller, {super.key});

  final AudioRoomController controller;

  @override
  Widget build(BuildContext context) {
    final room = controller.room;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Public Room"),
        ),
        body: controller.loading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : controller.error != null
                ? Center(
                    child: Text(
                      controller.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : StreamBuilder(
                    stream: room.events.streamCtrl.stream,
                    builder: (context, _) {
                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        children: [
                          if (room.localParticipant != null)
                            ListTile(
                              title: Text(room.localParticipant!.identity),
                              shape: room.localParticipant!.isSpeaking
                                  ? RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                                      side: const BorderSide(),
                                    )
                                  : null,
                              trailing: IconButton(
                                onPressed: controller.toggleIsMuted,
                                icon: Icon(
                                  controller.isMuted ? Icons.mic_off : Icons.mic,
                                ),
                              ),
                            ),
                          ...room.remoteParticipants.values.map(
                            (participant) => ListTile(
                              title: Text(participant.identity),
                              shape: participant.isSpeaking
                                  ? RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                                      side: const BorderSide(),
                                    )
                                  : null,
                              trailing: Icon(
                                participant.isMuted ? Icons.mic_off : Icons.mic,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          FilledButton(
                            onPressed: controller.leaveRoom,
                            child: const Text("Leave Room"),
                          ),
                        ],
                      );
                    },
                  ),
      ),
    );
  }
}
