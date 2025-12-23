import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/nearby/create_profile_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({
    super.key,
    required this.lat,
    required this.long,
  });

  final double lat;
  final double long;

  @override
  State<CreateProfile> createState() => CreateProfileController();
}

class CreateProfileController extends State<CreateProfile> {
  final formKey = GlobalKey<FormState>();
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final plateController = TextEditingController();
  final colorController = TextEditingController();

  bool loading = false;
  String? error;

  Future<void> createProfile() async {
    final l10n = L10n.of(context);

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final mxId = Matrix.of(context).client.userID!;
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final locationString = 'POINT(${widget.long} ${widget.lat})';

      await Supabase.instance.client.from('drivers').upsert({
        'id': userId,
        'car_make': makeController.text,
        'car_model': modelController.text,
        'car_year': yearController.text,
        'car_plate': plateController.text,
        'car_color': colorController.text,
        'is_sharing': true,
        'location': locationString,
        'mx_id': mxId,
      });

      context.go('/main/nearby');
    } catch (e) {
      debugPrint('Error creating profile: $e');
      setState(() {
        loading = false;
        error = l10n.nearbyCreateProfileError;
      });
    }
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate() == true) {
      final l10n = L10n.of(context);

      showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(l10n.nearbyCreateProfileConfirmDialogTitle),
            content: Text(l10n.nearbyCreateProfileConfirmDialogBody),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  createProfile();
                },
                child: Text(l10n.nearbyCreateProfileConfirmDialogYes),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(l10n.nearbyCreateProfileConfirmDialogNo),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CreateProfileView(controller: this);
  }

  @override
  void dispose() {
    makeController.dispose();
    modelController.dispose();
    yearController.dispose();
    plateController.dispose();
    super.dispose();
  }
}
