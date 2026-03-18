import 'package:fluffychat/config/colors.dart';
import 'package:fluffychat/config/secrets.dart';
import 'package:fluffychat/pages/nearby/car_number_plate.dart';
import 'package:fluffychat/pages/nearby/nearby_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class NearbyMapView extends StatelessWidget {
  const NearbyMapView({
    super.key,
    required this.controller,
  });

  final NearbyMapController controller;

  Marker buildMarker(BuildContext context, Map<String, dynamic> driver) {
    final theme = Theme.of(context);

    return Marker(
      point: LatLng(driver['lat'], driver['long']),
      width: 100.0,
      height: 100.0,
      child: GestureDetector(
        onTap: () => controller.widget.navigateToRating(driver['id']),
        child: Column(
          children: [
            Chip(
              backgroundColor: CarNumberPlate.plateBackgroundColor,
              label: Text(
                driver['car_plate'],
                style: theme.textTheme.labelSmall,
              ),
            ),
            const Icon(
              Icons.drive_eta_rounded,
              color: AppColors.red1,
              size: 48,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: controller.animatedMapController.mapController,
      options: MapOptions(
        initialCenter: controller.widget.currentPosition,
        initialZoom: controller.zoom,
        maxZoom: 20,
        minZoom: 0,
      ),
      children: [
        TileLayer(
          maxZoom: 20,
          minZoom: 0,
          urlTemplate: Secrets.kMapboxTileUrl,
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: controller.widget.currentPosition,
              child: const Icon(
                Icons.drive_eta_rounded,
                color: AppColors.black1,
                size: 48,
              ),
            ),
            ...controller.widget.drivers.map(
              (e) => buildMarker(context, e),
            ),
          ],
        ),
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Column(
            children: [
              IconButton.filled(
                onPressed: controller.onPressedZoomIn,
                icon: const Icon(Icons.zoom_in),
              ),
              IconButton.filled(
                onPressed: controller.onPressedZoomOut,
                icon: const Icon(Icons.zoom_out),
              ),
              IconButton.filled(
                onPressed: controller.onPressedCurrentLocation,
                icon: const Icon(Icons.location_searching),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
