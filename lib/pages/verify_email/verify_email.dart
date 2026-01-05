import 'package:fluffychat/config/secrets.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/verify_email/verify_email_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix_api_lite.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => VerifyEmailController();
}

class VerifyEmailController extends State<VerifyEmail> {
  static const String sendAttemptKey = 'app.cirkles.verify_email.sendAttempt';
  static const String sidKey = 'app.cirkles.verify_email.sid';
  static const String emailKey = 'app.cirkles.verify_email.email';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? error;
  bool loading = false;
  bool showVerify = false;
  String? sid;
  bool obscurePassword = true;

  void toggleObscurePassword() {
    setState(() => obscurePassword = !obscurePassword);
  }

  Future<void> verify() async {
    final router = GoRouter.of(context);

    if (sid == null) return;

    if (passwordController.text.isEmpty) {
      setState(() => passwordError = L10n.of(context).pleaseEnterYourPassword);
    } else {
      setState(() => passwordError = null);
    }

    setState(() => loading = true);

    final client = Matrix.of(context).client;

    if (client.userID == null) {
      if (mounted) {
        setState(() {
          loading = false;
          error = "UserID is null";
        });
      }
      return;
    }

    try {
      await client.add3PID(
        Secrets.kRegisterEmailTokenSecret,
        sid!,
        auth: AuthenticationPassword(
          password: passwordController.text,
          identifier: AuthenticationUserIdentifier(
            user: client.userID!,
          ),
        ),
      );

      router.go("/main");
    } on MatrixException catch (e) {
      debugPrint('Error: $e');
      setState(() {
        error = e.errorMessage;
      });
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> submit() async {
    if (emailController.text.isEmpty) {
      setState(() => emailError = L10n.of(context).pleaseEnterYourEmail);
    } else {
      setState(() => emailError = null);
    }

    setState(() => loading = true);

    try {
      final matrix = Matrix.of(context);

      final sendAttempt = matrix.store.getInt(sendAttemptKey) ?? 1;

      final requestTokenResponse = await Matrix.of(context).client.requestTokenToRegisterEmail(
            Secrets.kRegisterEmailTokenSecret,
            emailController.text,
            sendAttempt,
          );

      await matrix.store.setInt(sendAttemptKey, sendAttempt + 1);
      await matrix.store.setString(sidKey, requestTokenResponse.sid);
      await matrix.store.setString(emailKey, emailController.text);

      setState(() {
        sid ??= requestTokenResponse.sid;
        loading = false;
        showVerify = true;
      });
    } on MatrixException catch (e) {
      Logs().e("$e");
      setState(() {
        error = e.errorMessage;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final savedSid = Matrix.of(context).store.getString(sidKey);
      final savedEmail = Matrix.of(context).store.getString(emailKey);

      if (savedSid != null && savedEmail != null) {
        setState(() {
          sid = savedSid;
          emailController.text = savedEmail;
          showVerify = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return VerifyEmailView(this);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
