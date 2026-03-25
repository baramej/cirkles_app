import 'package:fluffychat/config/colors.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/moments/moments.dart';
import 'package:fluffychat/pages/moments/station_tile.dart';
import 'package:flutter/material.dart';

class MomentsView extends StatelessWidget {
  const MomentsView({
    super.key,
    required this.controller,
  });

  final MomentsController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).moments),
        centerTitle: true,
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
                      style: const TextStyle(color: AppColors.red1),
                    ),
                  )
                : Column(
                    children: [
                      Text(
                        L10n.of(context).momentsHeadline,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: controller.stations.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                          itemBuilder: (context, index) => StationCard(
                            setStationCardController: (c) => controller.setStationCardController(c),
                            station: controller.stations[index],
                            player: controller.player,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
