import 'package:flutter/material.dart';

class RouteExperienceIcon {
  static IconData toIconData(String name) {
    switch (name) {
      case 'wifi':
        return Icons.wifi;
      case 'parking':
        return Icons.local_parking;
      case 'restaurant':
        return Icons.restaurant;
      case 'gas':
        return Icons.local_gas_station;
      case 'coffee':
        return Icons.coffee;
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      case 'dessert':
        return Icons.cake;
      case 'icecream':
        return Icons.icecream;
      case 'scenicDrive':
        return Icons.landscape;
      case 'longDrive':
        return Icons.directions_car;
      case 'nightDrive':
        return Icons.nightlight_round;
      case 'quiteRoute':
        return Icons.route;
      case 'relaxing':
        return Icons.spa;
      case 'adventure':
        return Icons.hiking;
      case 'romantic':
        return Icons.favorite;
      case 'familyFriendly':
        return Icons.family_restroom;
      case 'walk':
        return Icons.directions_walk;
      case 'corniche':
        return Icons.waves;
      case 'hiddenGems':
        return Icons.diamond;
      case 'seaView':
        return Icons.beach_access;
      case 'mountainView':
        return Icons.terrain;
      case 'spaceDestination':
        return Icons.rocket_launch;
      default:
        return Icons.explore;
    }
  }
}
