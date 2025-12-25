import 'package:fluffychat/config/colors.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/circles/rooms.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class RoomsView extends StatelessWidget {
  const RoomsView(this.controller, {super.key});

  final RoomsController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(L10n.of(context).circles),
        actions: [
          if (controller.myCircles.isEmpty)
            IconButton.filled(
              onPressed: controller.onPressedNewCircle,
              icon: const Icon(Icons.add),
              color: theme.colorScheme.onPrimary,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: controller.loading
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
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        L10n.of(context).circlesHeadline,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        L10n.of(context).myCircles,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16.0),
                      if (controller.myCircles.isNotEmpty)
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: controller.myCircles.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                          itemBuilder: (context, index) => RoomListTile(
                            onPressedDelete: controller.loading
                                ? null
                                : () => controller.deleteCircle(
                                      controller.myCircles[index]['id'],
                                    ),
                            onPressedJoin: controller.loading
                                ? null
                                : () => controller.getAccessToken(
                                      controller.myCircles[index]['name'],
                                    ),
                            data: controller.myCircles[index],
                          ),
                        )
                      else
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(16.0),
                          ),
                          tileColor: AppColors.blueGrey,
                          title: Text(
                            L10n.of(context).myCirclesEmpty,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 16.0),
                      Text(
                        L10n.of(context).publicCircles,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16.0),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: controller.circles.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                          itemBuilder: (context, index) => RoomListTile(
                            onPressedDelete: controller.loading
                                ? null
                                : () => controller.deleteCircle(
                                      controller.circles[index]['id'],
                                    ),
                            onPressedJoin: controller.loading
                                ? null
                                : () => controller.getAccessToken(
                                      controller.circles[index]['name'],
                                    ),
                            data: controller.circles[index],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class RoomListTile extends StatelessWidget {
  const RoomListTile({
    super.key,
    required this.data,
    required this.onPressedJoin,
    required this.onPressedDelete,
  });

  final Map<String, dynamic> data;
  final void Function()? onPressedJoin;
  final void Function()? onPressedDelete;

  @override
  Widget build(BuildContext context) {
    final canDelete = Matrix.of(context).client.userID?.localpart == data['username'];

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16.0),
      ),
      tileColor: AppColors.blueGrey,
      title: Text(
        data['name'],
        textAlign: TextAlign.center,
      ),
      subtitle: Center(
        child: OverflowBar(
          spacing: 8.0,
          overflowSpacing: 8.0,
          children: [
            FilledButton(
              onPressed: onPressedJoin,
              child: const Text("Join Now"),
            ),
            if (canDelete)
              FilledButton(
                onPressed: onPressedDelete,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.red1,
                  foregroundColor: AppColors.white1,
                ),
                child: const Text("Delete"),
              ),
          ],
        ),
      ),
    );
  }
}
