import 'dart:io';

import 'package:fluffychat/config/colors.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/new_route/new_route.dart';
import 'package:flutter/material.dart';

class NewRouteView extends StatelessWidget {
  const NewRouteView({
    super.key,
    required this.controller,
  });

  final NewRouteController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).newRoute),
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
                : Form(
                    key: controller.newRouteFormKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: controller.nameController,
                          autofocus: true,
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? L10n.of(context).nameRequired : null,
                          decoration: InputDecoration(
                            labelText: L10n.of(context).name,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: controller.descriptionController,
                          maxLines: 4,
                          validator: (value) => value == null || value.trim().isEmpty
                              ? L10n.of(context).newRouteDescriptionRequired
                              : null,
                          decoration: InputDecoration(
                            labelText: L10n.of(context).newRouteDescription,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          readOnly: true,
                          validator: (_) => controller.image == null ? L10n.of(context).newRouteImageRequired : null,
                          decoration: InputDecoration(
                            labelText: L10n.of(context).newRouteImage,
                            prefix: controller.image == null
                                ? null
                                : Image.file(
                                    File(controller.image!.path),
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.cover,
                                  ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffix: FilledButton(
                              onPressed: controller.pickImage,
                              child: Text(
                                controller.image == null
                                    ? L10n.of(context).newRouteImageChoose
                                    : L10n.of(context).newRouteImageChange,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<Map<String, dynamic>>(
                          initialValue: controller.selectedCategory,
                          items: controller.categories
                              .map(
                                (e) => DropdownMenuItem<Map<String, dynamic>>(
                                  value: e,
                                  child: Text(
                                    Localizations.localeOf(context).languageCode == "ar" ? e['name_ar'] : e['name'],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) => controller.setCategory(value),
                          validator: (value) => value == null ? L10n.of(context).newRouteCategoryRequired : null,
                          decoration: InputDecoration(
                            labelText: L10n.of(context).newRouteCategory,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: controller.durationController,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? L10n.of(context).newRouteDurationRequired : null,
                          decoration: InputDecoration(
                            labelText: L10n.of(context).newRouteDuration,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: controller.kmsController,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? L10n.of(context).newRouteKmsRequired : null,
                          decoration: InputDecoration(
                            labelText: L10n.of(context).newRouteKms,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: controller.urlController,
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? L10n.of(context).newRouteUrlRequired : null,
                          decoration: InputDecoration(
                            labelText: L10n.of(context).newRouteUrl,
                            helperText: L10n.of(context).newRouteUrlHelp,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Wrap(
                          spacing: 16.0,
                          runSpacing: 16.0,
                          children: controller.experiences
                              .map(
                                (e) => CheckboxListTile.adaptive(
                                  value: controller.selectedExperiences.contains(e['id']),
                                  onChanged: (value) {
                                    if (value == true) {
                                      controller.selectExperience(e['id']);
                                    } else {
                                      controller.unselectExperience(e['id']);
                                    }
                                  },
                                  title: Text(
                                    Localizations.localeOf(context).languageCode == 'ar' ? e['name_ar'] : e['name'],
                                  ),
                                ),
                              )
                              .toList(),
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
