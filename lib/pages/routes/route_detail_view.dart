import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/routes/route_detail.dart';
import 'package:fluffychat/pages/routes/route_experience_icon.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteDetailView extends StatelessWidget {
  const RouteDetailView({
    super.key,
    required this.controller,
  });

  final RouteDetailController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: controller.route != null
            ? Text(
                controller.route!['name'],
                style: theme.textTheme.titleLarge,
              )
            : null,
        actions: [
          if (controller.canDelete)
            IconButton(
              onPressed: () async {
                final result =
                    await showOkCancelAlertDialog(context: context, title: L10n.of(context).deleteRouteConfirm);
                if (result == OkCancelResult.ok) {
                  controller.deleteRoute();
                }
              },
              icon: const Icon(CupertinoIcons.delete),
              color: Colors.red,
            ),
        ],
      ),
      body: controller.loading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : controller.error != null
              ? Center(
                  child: Text(
                    controller.error!,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: controller.route != null
                      ? [
                          SizedBox(
                            height: 250.0,
                            child: Image.network(
                              controller.route!['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                              shrinkWrap: true,
                              children: [
                                Text(
                                  controller.route!['description'],
                                ),
                                const SizedBox(height: 16.0),
                                Text(
                                  L10n.of(context).routeDetailDetails,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Wrap(
                                  spacing: 16.0,
                                  runSpacing: 16.0,
                                  children: [
                                    RouteDetailTextWithIcon(
                                      text: L10n.of(context).routeKms(
                                        controller.route!['kms'].toString(),
                                      ),
                                      icon: const Icon(Icons.local_gas_station),
                                    ),
                                    RouteDetailTextWithIcon(
                                      text: controller.route!['category_id']['name'],
                                      icon: const Icon(Icons.waves),
                                    ),
                                    RouteDetailTextWithIcon(
                                      text: L10n.of(context).routeDuration(
                                        (controller.route!['duration'] ~/ 60).toString(),
                                        (controller.route!['duration'] % 60).toString(),
                                      ),
                                      icon: const Icon(Icons.time_to_leave),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                if (controller.experiences.isNotEmpty)
                                  Text(
                                    L10n.of(context).routeDetailExperiences,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                if (controller.experiences.isNotEmpty) const SizedBox(height: 8.0),
                                if (controller.experiences.isNotEmpty)
                                  Wrap(
                                    spacing: 16.0,
                                    runSpacing: 16.0,
                                    children: controller.experiences
                                        .map(
                                          (e) => RouteDetailTextWithIcon(
                                            text: Localizations.localeOf(context).languageCode == 'ar'
                                                ? e['experience_id']['name_ar']
                                                : e['experience_id']['name'],
                                            icon: Icon(
                                              RouteExperienceIcon.toIconData(
                                                e['experience_id']['icon'],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                            child: FilledButton.icon(
                              onPressed: controller.openNavigation,
                              label: Text(
                                L10n.of(context).routeDetailStartNavigation,
                              ),
                              icon: const Icon(Icons.route_outlined),
                            ),
                          ),
                        ]
                      : [],
                ),
    );
  }
}

class RouteDetailTextWithIcon extends StatelessWidget {
  const RouteDetailTextWithIcon({
    super.key,
    required this.text,
    required this.icon,
  });

  final String text;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 4.0),
        Text(text),
      ],
    );
  }
}
