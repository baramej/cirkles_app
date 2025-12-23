import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/nearby/my_profile/my_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({
    super.key,
    required this.driverId,
  });

  final String driverId;

  @override
  State<MyProfile> createState() => MyProfileController();
}

class MyProfileController extends State<MyProfile> {
  Map<String, dynamic>? myProfile;
  bool loading = true;
  String? error;

  Future<Map<String, dynamic>?> getMyProfile(String driverId) async {
    try {
      final response = await Supabase.instance.client.rpc(
        'get_driver_profile_by_id',
        params: {'driver_id': driverId},
      ) as List;

      if (response.isNotEmpty) {
        return Map<String, dynamic>.from(response.first as Map);
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final l10n = L10n.of(context);

      final profile = await getMyProfile(widget.driverId);

      if (profile == null) {
        setState(() {
          loading = false;
          error = l10n.nearbyMyProfileError;
        });
      } else {
        setState(() {
          loading = false;
          myProfile = profile;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyProfileView(controller: this);
  }
}
