import 'package:fluffychat/config/colors.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/nearby/nearby.dart';
import 'package:fluffychat/pages/nearby/nearby_list_view.dart';
import 'package:fluffychat/pages/nearby/nearby_map.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class NearbyView extends StatelessWidget {
  const NearbyView({
    super.key,
    required this.controller,
  });

  final NearbyController controller;

  @override
  Widget build(BuildContext context) {
    final matrix = Matrix.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          L10n.of(context).homeDiscoverNearby,
        ),
        actions: [
          Switch.adaptive(
            value: controller.isSharing,
            onChanged: controller.onChangedIsSharing,
          ),
          FutureBuilder<Profile>(
            future: matrix.client.isLogged() ? matrix.client.fetchOwnProfile() : null,
            builder: (context, snapshot) {
              return Material(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(99),
                color: Colors.transparent,
                child: Center(
                  child: Avatar(
                    onTap: controller.navigateToProfile,
                    mxContent: snapshot.data?.avatarUrl,
                    name: snapshot.data?.displayName ?? matrix.client.userID?.localpart,
                    size: 42,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: controller.loading
          ? const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : controller.error != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Center(
                    child: Text(
                      controller.error!,
                      style: const TextStyle(color: AppColors.red1),
                    ),
                  ),
                )
              : controller.isSharing
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              ChoiceChip(
                                label: const Text("List View"),
                                selected: controller.isListView,
                                onSelected: (_) => controller.showListView(),
                              ),
                              ChoiceChip(
                                label: const Text("Map View"),
                                selected: !controller.isListView,
                                onSelected: (_) => controller.showMapView(),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: controller.isListView
                              ? NearbyListView(
                                  navigateToRating: controller.navigateToRating,
                                  drivers: controller.drivers,
                                  shrinkWrap: true,
                                )
                              : NearbyMap(
                                  drivers: controller.drivers,
                                  currentPosition: controller.currentPosition,
                                  navigateToRating: controller.navigateToRating,
                                ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Center(
                        child: Text(
                          L10n.of(context).nearbySharingOff,
                        ),
                      ),
                    ),
    );
  }
}
