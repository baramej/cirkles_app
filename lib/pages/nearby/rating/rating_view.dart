import 'package:fluffychat/config/colors.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/nearby/car_number_plate.dart';
import 'package:fluffychat/pages/nearby/rating/rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:matrix/matrix.dart';

class RatingView extends StatelessWidget {
  const RatingView({
    super.key,
    required this.controller,
  });

  final RatingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          L10n.of(context).nearbyRatingTitle,
        ),
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
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  children: [
                    Material(
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
                                    "@${controller.myProfile!['mx_id']}".localpart!,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star),
                                    const SizedBox(width: 4),
                                    Text("${controller.myProfile!['average_rating']}"),
                                    const SizedBox(width: 4),
                                    Text("(${controller.myProfile!['review_count']})"),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            CarNumberPlate(number: controller.myProfile!['car_plate']),
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
                                        "${controller.myProfile!['car_make']} ${controller.myProfile!['car_model']} ${controller.myProfile!['car_year']}",
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
                                        "${controller.myProfile!['car_color']}",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      L10n.of(context).nearbyRatingHeadline,
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    RatingBar.builder(
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: controller.onRatingUpdate,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: controller.rating < 1 || controller.rating > 5 ? null : controller.submit,
                      child: Text(L10n.of(context).submit),
                    ),
                  ],
                ),
    );
  }
}
