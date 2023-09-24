import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapCart extends StatelessWidget {
  const MapCart({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(33.589886, -7.603869),
        zoom: 9.2,
      ),
      nonRotatedChildren: [
        // RichAttributionWidget(
        //   attributions: [
        //     TextSourceAttribution('OpenStreetMap contributors', onTap: () {}),
        //   ],
        // ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
      ],
    );
  }
}
