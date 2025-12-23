import 'package:fluffychat/config/colors.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/nearby/car_number_plate.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class NearbyListView extends StatelessWidget {
  const NearbyListView({
    super.key,
    required this.drivers,
    required this.navigateToRating,
    this.shrinkWrap = false,
  });

  final List<Map<String, dynamic>> drivers;
  final void Function(String driverId) navigateToRating;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (drivers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.time_to_leave),
            const SizedBox(height: 16),
            Text(
              L10n.of(context).nearbyListViewEmpty,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shrinkWrap: shrinkWrap,
      itemCount: drivers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final driver = drivers[index];
        return Material(
          color: AppColors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "@${driver['mx_id']}".localpart!,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star),
                        const SizedBox(width: 4),
                        Text("${driver['average_rating']}"),
                        const SizedBox(width: 4),
                        Text("(${driver['review_count']})"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CarNumberPlate(number: driver['car_plate']),
                const SizedBox(height: 16),
                Material(
                  color: AppColors.blueGreyCard,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(8),
                    side: const BorderSide(color: AppColors.blueGreyCardBorder),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.time_to_leave),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "${driver['car_make']} ${driver['car_model']} ${driver['car_year']}",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Material(
                  color: AppColors.blueGreyCard,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(8),
                    side: const BorderSide(color: AppColors.blueGreyCardBorder),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.color_lens),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "${driver['car_color']}",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () => navigateToRating(driver['id']),
                  child: Text(L10n.of(context).nearbyRatingButtonText),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
