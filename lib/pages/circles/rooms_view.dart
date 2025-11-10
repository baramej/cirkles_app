import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/circles/rooms.dart';
import 'package:flutter/material.dart';

class RoomsView extends StatelessWidget {
  const RoomsView(this.controller, {super.key});

  final RoomsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(L10n.of(context).circles),
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
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  children: [
                    ListTile(
                      title: const Text("Public Room"),
                      trailing: FilledButton(
                        onPressed: controller.loading ? null : controller.joinRoom,
                        child: const Text("Join"),
                      ),
                    ),
                  ],
                ),
    );
  }
}
