import 'package:fluffychat/pages/nearby/nearby_map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';

class NearbyMap extends StatefulWidget {
  const NearbyMap({
    super.key,
    required this.drivers,
    required this.currentPosition,
    required this.navigateToRating,
  });

  final List<Map<String, dynamic>> drivers;
  final LatLng currentPosition;
  final void Function(String driverId) navigateToRating;

  @override
  State<NearbyMap> createState() => NearbyMapController();
}

class NearbyMapController extends State<NearbyMap> with TickerProviderStateMixin {
  late final animatedMapController = AnimatedMapController(vsync: this);
  double zoom = 17;

  void onPressedZoomIn() {
    final nZoom = zoom + 1;
    if (nZoom < 20) {
      setState(() {
        final center = animatedMapController.mapController.camera.center;
        animatedMapController.animateTo(dest: center, zoom: nZoom);
        zoom = nZoom;
      });
    }
  }

  void onPressedZoomOut() {
    final nZoom = zoom - 1;
    if (nZoom > 0) {
      setState(() {
        final center = animatedMapController.mapController.camera.center;
        animatedMapController.animateTo(dest: center, zoom: nZoom);
        zoom = nZoom;
      });
    }
  }

  void onPressedCurrentLocation() {
    animatedMapController.animateTo(
      dest: widget.currentPosition,
      zoom: zoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NearbyMapView(controller: this);
  }

  @override
  void dispose() {
    animatedMapController.dispose();
    super.dispose();
  }
}
