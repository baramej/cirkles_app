import 'dart:math';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'register.dart';

class RegisterView extends StatelessWidget {
  const RegisterView(this.controller, {super.key});

  final RegisterController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usernameHint = ['mercury', 'jupiter', 'sun', 'moon', 'earth'][Random().nextInt(5)];

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).register),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          if (controller.error != null)
            Text(
              controller.error!,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          if (controller.error != null) const SizedBox(height: 16.0),
          TextField(
            controller: controller.usernameController,
            readOnly: controller.loading,
            autocorrect: false,
            autofillHints: controller.loading ? null : [AutofillHints.username],
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.account_box_outlined),
              errorText: controller.usernameError,
              labelText: L10n.of(context).username,
              hintText: usernameHint,
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            readOnly: controller.loading,
            autocorrect: false,
            autofillHints: controller.loading ? null : [AutofillHints.password],
            controller: controller.passwordController,
            textInputAction: TextInputAction.go,
            obscureText: !controller.showPassword,
            onSubmitted: (_) => controller.register(),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outlined),
              errorText: controller.passwordError,
              suffixIcon: IconButton(
                onPressed: controller.toggleShowPassword,
                icon: Icon(
                  controller.showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.black,
                ),
              ),
              hintText: '******',
              labelText: L10n.of(context).password,
            ),
          ),
          const SizedBox(height: 16.0),
          CheckboxListTile.adaptive(
            value: controller.isAgree,
            onChanged: (_) => controller.toggleIsAgree(),
            title: Text(L10n.of(context).registerEula),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            onPressed: controller.loading || !controller.isAgree ? null : controller.register,
            child: controller.loading ? const LinearProgressIndicator() : Text(L10n.of(context).register),
          ),
          TextButton(
            onPressed: () async {
              final url = Uri.parse("https://github.com/baramej/cirkles_app/wiki/Terms-&-Conditions");
              if (await canLaunchUrl(url)) {
                launchUrl(url);
              }
            },
            child: Text(L10n.of(context).registerTermsOfUse),
          ),
        ],
      ),
    );
  }
}
