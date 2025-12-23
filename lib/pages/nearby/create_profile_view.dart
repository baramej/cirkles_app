import 'package:fluffychat/config/colors.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/nearby/create_profile.dart';
import 'package:flutter/material.dart';

class CreateProfileView extends StatelessWidget {
  const CreateProfileView({
    super.key,
    required this.controller,
  });

  final CreateProfileController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          L10n.of(context).nearbyCreateProfile,
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
                      style: const TextStyle(color: AppColors.red1),
                    ),
                  )
                : Form(
                    key: controller.formKey,
                    child: ListView(
                      children: [
                        Text(
                          L10n.of(context).createProfileCarDetails,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: controller.makeController,
                          validator: (value) =>
                              value == null || value.isEmpty ? L10n.of(context).nearbyCreateProfileMakeRequired : null,
                          decoration: InputDecoration(
                            labelText: L10n.of(context).nearbyCreateProfileMake,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: controller.modelController,
                          validator: (value) =>
                              value == null || value.isEmpty ? L10n.of(context).nearbyCreateProfileModelRequired : null,
                          decoration: InputDecoration(
                            labelText: L10n.of(context).nearbyCreateProfileModel,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: controller.yearController,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value == null || value.isEmpty ? L10n.of(context).nearbyCreateProfileYearRequired : null,
                          decoration: InputDecoration(
                            labelText: L10n.of(context).nearbyCreateProfileYear,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: controller.colorController,
                          validator: (value) =>
                              value == null || value.isEmpty ? L10n.of(context).nearbyCreateProfileColorRequired : null,
                          decoration: InputDecoration(
                            labelText: L10n.of(context).nearbyCreateProfileColor,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: controller.plateController,
                          validator: (value) =>
                              value == null || value.isEmpty ? L10n.of(context).nearbyCreateProfilePlateRequired : null,
                          decoration: InputDecoration(
                            labelText: L10n.of(context).nearbyCreateProfilePlate,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          L10n.of(context).nearbyCreateProfileLocationPolicy,
                        ),
                        const SizedBox(height: 16.0),
                        FilledButton(
                          onPressed: controller.submit,
                          child: Text(
                            L10n.of(context).submit,
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
