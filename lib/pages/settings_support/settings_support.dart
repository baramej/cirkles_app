import 'package:dart_resend/dart_resend.dart';
import 'package:fluffychat/config/secrets.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/settings_support/settings_support_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsSupport extends StatefulWidget {
  const SettingsSupport({super.key});

  @override
  State<SettingsSupport> createState() => SettingsSupportController();
}

class SettingsSupportController extends State<SettingsSupport> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();

  bool loading = false;
  String? error;

  Future<void> submit() async {
    if (formKey.currentState!.validate() == true) {
      final l10n = L10n.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      setState(() {
        loading = true;
        error = null;
      });

      final resend = Resend.initialize(apiKey: Secrets.kResendApiKey).client;

      final response = await resend.email.sendEmail(
        from: 'Cirkles Support <support@cirkles.app>',
        to: <String>[emailController.text],
        subject: subjectController.text,
        text: descriptionController.text,
      );

      response.fold(
        onSuccess: (_) {
          setState(() {
            loading = false;
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(l10n.settingsSupportSuccess),
              ),
            );
            context.pop();
          });
        },
        onFailure: (e, m) {
          debugPrint("Error: $e");
          debugPrint("Message: $m");
          setState(() {
            loading = false;
            error = l10n.settingsSupportError;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSupportView(controller: this);
  }

  @override
  void dispose() {
    emailController.dispose();
    subjectController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
