import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/supabase_auth.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import 'register_view.dart';

class Register extends StatefulWidget {
  const Register({
    super.key,
    required this.client,
  });

  final Client client;

  @override
  State<Register> createState() => RegisterController();
}

class RegisterController extends State<Register> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String? usernameError;
  String? passwordError;
  String? error;
  bool loading = false;
  bool showPassword = false;

  void toggleShowPassword() => setState(() => showPassword = !loading && !showPassword);

  Future<void> register() async {
    final matrix = Matrix.of(context);
    if (usernameController.text.isEmpty) {
      setState(() => usernameError = L10n.of(context).pleaseEnterYourUsername);
    } else {
      setState(() => usernameError = null);
    }
    if (passwordController.text.isEmpty) {
      setState(() => passwordError = L10n.of(context).pleaseEnterYourPassword);
    } else {
      setState(() => passwordError = null);
    }

    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }

    setState(() => loading = true);

    final client = await matrix.getLoginClient();
    try {
      final response = await client.register(
        username: usernameController.text,
        password: passwordController.text,
        kind: AccountKind.user,
        auth: AuthenticationData(
          type: "m.login.dummy",
        ),
      );

      await SupabaseAuth.registerOrLogin(response.userId.localpart!);
    } on MatrixException catch (e) {
      setState(() {
        error = e.errorMessage;
      });
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RegisterView(this);
  }
}
