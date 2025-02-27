import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Pass your access token to MapboxOptions so you can load a map
  // String ACCESS_TOKEN = const String.fromEnvironment("ACCESS_TOKEN");
  String ACCESS_TOKEN =
      "pk.eyJ1IjoiZWFnZXJwayIsImEiOiJjbTduampmcDEwMW0wMmtzMno1aTBoa2JrIn0.ChS7s_tBEgceQ_pJ5MoCOA";
  MapboxOptions.setAccessToken(ACCESS_TOKEN);

  // Define options for your camera
  CameraOptions camera = CameraOptions(
      center: Point(coordinates: Position(-98.0, 39.5)),
      zoom: 2,
      bearing: 0,
      pitch: 0);

  // Run your application, passing your CameraOptions to the MapWidget
  runApp(MaterialApp(
      home: MapWidget(
    cameraOptions: camera,
  )));
}
