import 'package:fluffychat/config/colors.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/settings_support/settings_support.dart';
import 'package:flutter/material.dart';

class SettingsSupportView extends StatelessWidget {
  const SettingsSupportView({
    super.key,
    required this.controller,
  });

  final SettingsSupportController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !FluffyThemes.isColumnMode(context),
        centerTitle: FluffyThemes.isColumnMode(context),
        title: Text(L10n.of(context).settingsSupport),
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
                : Form(
                    key: controller.formKey,
                    child: ListView(
                      children: [
                        Text(
                          l10n.settingsSupportTitle,
                          style: theme.textTheme.headlineSmall,
                        ),
                        Text(
                          l10n.settingsSupportSubtitle,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: controller.emailController,
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? l10n.settingsSupportYourEmailRequired : null,
                          decoration: InputDecoration(
                            labelText: l10n.settingsSupportYourEmail,
                            hintText: "name@example.com",
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: controller.subjectController,
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? l10n.settingsSupportSubjectRequired : null,
                          decoration: InputDecoration(
                            labelText: l10n.settingsSupportSubject,
                            hintText: l10n.settingsSupportSubjectPlaceholder,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: controller.descriptionController,
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? l10n.settingsSupportDescriptionRequired : null,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: l10n.settingsSupportDescription,
                            hintText: l10n.settingsSupportDescriptionPlaceholder,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: controller.submit,
                          label: Text(l10n.settingsSupportSubmit),
                          icon: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
