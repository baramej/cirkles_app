import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/nearby/create_profile_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const List<Map<String, String>> carColors = [
  {'name': 'Black', 'nameAr': 'أسود'},
  {'name': 'White', 'nameAr': 'أبيض'},
  {'name': 'Silver', 'nameAr': 'فضي'},
  {'name': 'Gray', 'nameAr': 'رمادي'},
  {'name': 'Red', 'nameAr': 'أحمر'},
  {'name': 'Blue', 'nameAr': 'أزرق'},
  {'name': 'Green', 'nameAr': 'أخضر'},
  {'name': 'Yellow', 'nameAr': 'أصفر'},
  {'name': 'Orange', 'nameAr': 'برتقالي'},
  {'name': 'Brown', 'nameAr': 'بني'},
  {'name': 'Beige', 'nameAr': 'بيج'},
  {'name': 'Gold', 'nameAr': 'ذهبي'},
  {'name': 'Bronze', 'nameAr': 'برونزي'},
  {'name': 'Purple', 'nameAr': 'بنفسجي'},
  {'name': 'Pink', 'nameAr': 'وردي'},
];

const List<String> plateCodes = [
  'A',
  'A A',
  'A B',
  'A D',
  'A K',
  'A M',
  'A R',
  'A S',
  'A W',
  'A Y',
  'B',
  'B A',
  'B B',
  'B D',
  'B H',
  'B K',
  'B M',
  'B R',
  'B S',
  'B W',
  'B Y',
  'D',
  'D A',
  'D D',
  'D H',
  'D K',
  'D M',
  'D R',
  'D S',
  'D W',
  'D Y',
  'H',
  'H A',
  'H B',
  'H D',
  'H H',
  'H K',
  'H M',
  'H R',
  'H S',
  'H W',
  'H Y',
  'J',
  'K',
  'K A',
  'K B',
  'K H',
  'K K',
  'K M',
  'L K',
  'M',
  'M A',
  'M B',
  'M D',
  'M H',
  'M K',
  'M L',
  'M M',
  'M R',
  'M S',
  'M W',
  'M Y',
  'R',
  'R A',
  'R B',
  'R D',
  'R H',
  'R K',
  'R M',
  'R R',
  'R S',
  'R W',
  'R Y',
  'S',
  'S H',
  'S S',
  'T',
  'T A',
  'T B',
  'T T',
  'W',
  'W A',
  'W B',
  'W K',
  'W R',
  'W W',
  'Y',
  'Y A',
  'Y B',
  'Y D',
  'Y M',
  'Y R',
  'Y S',
  'Y W',
  'Y Y',
];

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
  String plateCode = plateCodes[0];

  bool loading = false;
  String? error;

  void setPlateCode(String code) {
    setState(() {
      plateCode = code;
    });
  }

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
        'car_plate': "$plateCode ${plateController.text}",
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
