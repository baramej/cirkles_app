import 'package:fluffychat/config/colors.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/nearby/car_number_plate.dart';
import 'package:fluffychat/pages/nearby/my_profile/my_profile.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class MyProfileView extends StatelessWidget {
  const MyProfileView({
    super.key,
    required this.controller,
  });

  final MyProfileController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          L10n.of(context).nearbyMyProfile,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                : ListView(
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
                    ],
                  ),
      ),
    );
  }
}
