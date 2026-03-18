import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/new_circle/new_circle_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewCircle extends StatefulWidget {
  const NewCircle({super.key});

  @override
  State<NewCircle> createState() => NewCircleController();
}

class NewCircleController extends State<NewCircle> {
  final newCircleFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final nameFocus = FocusNode();
  bool isLoading = false;
  String? error;

  Future<void> onSubmit() async {
    if (newCircleFormKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final l10n = L10n.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final client = Matrix.of(context).client;

      try {
        await Supabase.instance.client.from('circle').insert({
          "name": nameController.text.trim(),
          "username": client.userID?.localpart,
        });

        setState(() {
          isLoading = false;
          error = null;
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(l10n.newCircleSuccess),
            ),
          );
          context.pop(true);
        });
      } catch (err) {
        setState(() {
          isLoading = false;
          error = l10n.newCircleError;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NewCircleView(controller: this);
  }

  @override
  void dispose() {
    nameController.dispose();
    nameFocus.dispose();
    super.dispose();
  }
}
