import 'package:fluffychat/config/colors.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/routes/routes.dart';
import 'package:flutter/material.dart';

enum RoutesFilter { shortest, longest }

class RoutesView extends StatelessWidget {
  const RoutesView({
    super.key,
    required this.controller,
  });

  final RoutesController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).routes),
        centerTitle: true,
        actions: [
          if (!controller.hasOwnRoute)
            IconButton.filled(
              onPressed: controller.navigateToNewRoute,
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
                      style: const TextStyle(
                        color: AppColors.red1,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Text(
                        L10n.of(context).routesHeadline,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: 50.0,
                        child: Center(
                          child: Row(
                            children: [
                              MenuAnchor(
                                menuChildren: [
                                  MenuItemButton(
                                    onPressed: controller.sortRoutesByShortest,
                                    child: Text(L10n.of(context).routesFilterShortest),
                                  ),
                                  MenuItemButton(
                                    onPressed: controller.sortRoutesByLongest,
                                    child: Text(L10n.of(context).routesFilterLongest),
                                  ),
                                ],
                                builder: (BuildContext context, MenuController controller, Widget? child) {
                                  return IconButton(
                                    onPressed: () {
                                      if (controller.isOpen) {
                                        controller.close();
                                      } else {
                                        controller.open();
                                      }
                                    },
                                    icon: const Icon(Icons.sort),
                                  );
                                },
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.categories.length,
                                  separatorBuilder: (_, __) => const SizedBox(width: 16.0),
                                  itemBuilder: (context, index) => FilterChip(
                                    label: Text(
                                      controller.categories[index]['name'],
                                    ),
                                    backgroundColor: AppColors.blueGrey,
                                    selected: controller.selectedCategory?['id'] == controller.categories[index]['id'],
                                    onSelected: (value) {
                                      if (value) {
                                        controller.setSelectedCategory(controller.categories[index]);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      if (controller.routes.isEmpty)
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.map),
                              const SizedBox(height: 16),
                              Text(
                                L10n.of(context).routesListViewEmpty,
                              ),
                            ],
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: controller.routes.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                            itemBuilder: (context, index) => RouteListTile(
                              onPressed: () => controller.navigateToRouteDetail(controller.routes[index]['id']),
                              data: controller.routes[index],
                            ),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }
}

class RouteListTile extends StatelessWidget {
  const RouteListTile({
    super.key,
    required this.data,
    required this.onPressed,
  });

  final Map<String, dynamic> data;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AppColors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: SizedBox(
              height: 150.0,
              child: Image.network(
                data['image'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  data['name'],
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_gas_station),
                        const SizedBox(width: 4.0),
                        Text(
                          L10n.of(context).routeKms(data['kms'].toString()),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.waves),
                        const SizedBox(width: 4.0),
                        Text(
                          "${data['category_id']['name']}",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.time_to_leave),
                        const SizedBox(width: 4.0),
                        Text(
                          L10n.of(context).routeDuration(
                            (data['duration'] ~/ 60).toString(),
                            (data['duration'] % 60).toString(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                FilledButton(
                  onPressed: onPressed,
                  child: Text(L10n.of(context).viewRoute),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
