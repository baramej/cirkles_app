import 'package:collection/collection.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/nearby/rating/rating_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Rating extends StatefulWidget {
  const Rating({
    super.key,
    required this.driverId,
  });

  final String driverId;

  @override
  State<Rating> createState() => RatingController();
}

class RatingController extends State<Rating> {
  bool loading = true;
  String? error;
  Map<String, dynamic>? myProfile;
  List<Map<String, dynamic>> myRatings = [];
  double rating = 0;

  bool get canRate => myRatings.any((e) => e['target_driver_id'] == widget.driverId) == false;

  Map<String, dynamic>? get previousRating =>
      myRatings.singleWhereOrNull((e) => e['target_driver_id'] == widget.driverId);

  Future<List<Map<String, dynamic>>> getMyRatings() async {
    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      if (uid == null) throw Exception("Uid not found");

      return await Supabase.instance.client.from('ratings').select().eq('rater_id', uid);
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

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
      final ratings = await getMyRatings();

      if (profile == null) {
        setState(() {
          loading = false;
          error = l10n.nearbyRatingError;
          myRatings = ratings;
        });
      } else {
        setState(() {
          loading = false;
          myProfile = profile;
          myRatings = ratings;
        });
      }
    });
  }

  void onRatingUpdate(double value) {
    setState(() {
      rating = value;
    });
  }

  Future<void> submit() async {
    final c = context;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = L10n.of(context);

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      if (uid == null) throw Exception("Uid not found");

      await Supabase.instance.client.from('ratings').upsert({
        'rater_id': uid,
        'target_driver_id': widget.driverId,
        'rating': rating.toInt(),
      });

      setState(() {
        loading = false;
        error = null;
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(l10n.nearbyRatingSuccess),
          ),
        );
        c.pop(true);
      });
    } catch (e) {
      debugPrint("Error rating driver: $e");
      setState(() {
        loading = false;
        error = l10n.nearbyRatingError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RatingView(controller: this);
  }
}
