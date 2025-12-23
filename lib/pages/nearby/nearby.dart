import 'dart:async';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/nearby/location_debouncer.dart';
import 'package:fluffychat/pages/nearby/nearby_view.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Nearby extends StatefulWidget {
  const Nearby({super.key});

  @override
  State<Nearby> createState() => NearbyController();
}

class NearbyController extends State<Nearby> {
  bool loading = true;
  String? error;
  Map<String, dynamic>? myDriverProfile;
  List<Map<String, dynamic>> drivers = [];
  bool isSharing = false;
  LatLng currentPosition = const LatLng(23.6006, 58.2827);
  final LocationDebouncer _debouncer = LocationDebouncer(const Duration(seconds: 30));
  StreamSubscription<Position>? _positionSubscription;
  bool isListView = true;

  void showListView() {
    setState(() {
      isListView = true;
    });
  }

  void showMapView() {
    setState(() {
      isListView = false;
    });
  }

  Future<void> updateMyLocation(double lat, double long, bool isSharing) async {
    if (myDriverProfile == null) return;

    // PostGIS expects: 'POINT(longitude latitude)'
    final point = 'POINT($long $lat)';
    final myProfile = Map<String, dynamic>.from(myDriverProfile!);

    myProfile['location'] = point;
    myProfile['is_sharing'] = isSharing;
    myProfile['updated_at'] = DateTime.now().toIso8601String();

    await Supabase.instance.client.from('drivers').upsert(myProfile);
  }

  Future<void> onChangedIsSharing(bool value) async {
    setState(() {
      isSharing = value;
      loading = true;
    });

    await updateMyLocation(currentPosition.latitude, currentPosition.longitude, value);
    List<Map<String, dynamic>>? nearbyDrivers;

    if (value) {
      nearbyDrivers = await getNearbyDrivers(currentPosition.latitude, currentPosition.longitude);
    }

    setState(() {
      loading = false;
      if (nearbyDrivers != null) {
        drivers = nearbyDrivers;
      }
    });
  }

  Future<LatLng?> getCurrentPosition() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever ||
          permission == LocationPermission.unableToDetermine) {
        return null;
      }
    }

    final position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  Future<Map<String, dynamic>?> getMyDriverProfile() async {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return null;

    final response = await Supabase.instance.client.from('drivers').select().eq('id', uid);
    if (response.isEmpty) {
      return null;
    } else {
      return response.first;
    }
  }

  Future<List<Map<String, dynamic>>?> getNearbyDrivers(double myLat, double myLong) async {
    try {
      final response = await Supabase.instance.client.rpc(
        'get_nearby_drivers',
        params: {
          'my_lat': myLat,
          'my_long': myLong,
          'radius_meters': 5000, // 5km radius
        },
      );

      return (response as List).map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  void _listenToPositionUpdates() {
    _positionSubscription ??= Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100, // Only get updates if the user moves 100 meters
      ),
    ).listen((Position? position) {
      if (!isSharing) return;

      if (position == null) return;

      _debouncer.run(() async {
        setState(() {
          loading = true;
        });

        await updateMyLocation(
          position.latitude,
          position.longitude,
          true,
        );

        setState(() {
          loading = false;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final l10n = L10n.of(context);
      final position = await getCurrentPosition();
      if (position == null) {
        setError(l10n.nearbyLocationError);
        return;
      }

      final profile = await getMyDriverProfile();
      if (profile == null) {
        context.go(
          '/main/createProfile',
          extra: {
            'lat': position.latitude,
            'long': position.longitude,
          },
        );
        return;
      }

      final nearbyDrivers = await getNearbyDrivers(position.latitude, position.longitude);
      if (nearbyDrivers == null) {
        setError(l10n.nearbyLoadDriversError);
        return;
      }

      setState(() {
        loading = false;
        currentPosition = position;
        myDriverProfile = profile;
        isSharing = profile['is_sharing'];
        drivers = nearbyDrivers;

        _listenToPositionUpdates();
      });
    });
  }

  void setError(String? value) {
    setState(() {
      loading = false;
      error = value;
    });
  }

  void navigateToRating(String driverId) {
    context.push(
      '${GoRouter.of(context).routeInformationProvider.value.uri.path}/rating',
      extra: {'driverId': driverId},
    );
  }

  void navigateToProfile() {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return;

    context.push(
      '${GoRouter.of(context).routeInformationProvider.value.uri.path}/myProfile',
      extra: {'driverId': uid},
    );
  }

  @override
  Widget build(BuildContext context) {
    return NearbyView(controller: this);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _positionSubscription?.cancel();
    super.dispose();
  }
}
