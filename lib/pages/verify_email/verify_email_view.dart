import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/verify_email/verify_email.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView(this.controller, {super.key});

  final VerifyEmailController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).registerVerifyEmail),
      ),
      body: controller.showVerify
          ? ListView(
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
                Text(
                  L10n.of(context).registerEmailValidationText,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: controller.passwordController,
                  obscureText: controller.obscurePassword,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      controller.passwordError = L10n.of(context).pleaseEnterYourPassword;
                    } else {
                      controller.passwordError = null;
                    }
                  },
                  readOnly: controller.loading,
                  autocorrect: false,
                  autofillHints: controller.loading ? null : [AutofillHints.password],
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password),
                    labelText: L10n.of(context).password,
                    errorText: controller.passwordError,
                    suffixIcon: IconButton(
                      onPressed: controller.toggleObscurePassword,
                      icon: Icon(
                        controller.obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: Colors.black,
                      ),
                    ),
                    hintText: '******',
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed: controller.loading ? null : controller.verify,
                  child: controller.loading
                      ? const LinearProgressIndicator()
                      : Text(L10n.of(context).registerEmailValidationButtonText),
                ),
              ],
            )
          : ListView(
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
                Text(
                  L10n.of(context).registerVerifyEmailHeadline,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.emailController,
                  onChanged: (value) {
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (value.isEmpty) {
                      controller.emailError = L10n.of(context).registerEmailRequired;
                    } else if (!emailRegex.hasMatch(value)) {
                      controller.emailError = L10n.of(context).registerEmailInvalid;
                    } else {
                      controller.emailError = null;
                    }
                  },
                  readOnly: controller.loading,
                  autocorrect: false,
                  autofillHints: controller.loading ? null : [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelText: L10n.of(context).registerEmail,
                    errorText: controller.emailError,
                    hintText: "name@example.com",
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed: controller.loading ? null : controller.submit,
                  child: controller.loading ? const LinearProgressIndicator() : Text(L10n.of(context).submit),
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(
                    L10n.of(context).registerVerifyEmailSkipForNow,
                  ),
                ),
              ],
            ),
    );
  }
}
