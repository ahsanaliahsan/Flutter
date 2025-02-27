import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Pass your access token to MapboxOptions so you can load a map
  String ACCESS_TOKEN =
      "pk.eyJ1IjoiZWFnZXJwayIsImEiOiJjbTduampmcDEwMW0wMmtzMno1aTBoa2JrIn0.ChS7s_tBEgceQ_pJ5MoCOA";
  MapboxOptions.setAccessToken(ACCESS_TOKEN);

  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<Map<String, double>>(
          future: _geocodeAddress(
              "Shifa International Hospital, Pitras Bukhari Road, H-8/4, Islamabad, Pakistan"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return Center(child: Text("No data found"));
            } else {
              final coordinates = snapshot.data!;
              return MapWidget(
                cameraOptions: CameraOptions(
                  center: Point(
                      coordinates: Position(
                          coordinates['longitude']!, coordinates['latitude']!)),
                  zoom: 16, // Adjust zoom level for a closer view
                  bearing: 0,
                  pitch: 0,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Function to geocode the address using Mapbox Geocoding API
  Future<Map<String, double>> _geocodeAddress(String address) async {
    final accessToken =
        "pk.eyJ1IjoiZWFnZXJwayIsImEiOiJjbTduampmcDEwMW0wMmtzMno1aTBoa2JrIn0.ChS7s_tBEgceQ_pJ5MoCOA";
    final encodedAddress = Uri.encodeComponent(address);
    final url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$encodedAddress.json?access_token=$accessToken";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['features'] != null && data['features'].isNotEmpty) {
        final coordinates = data['features'][0]['center'];
        return {
          'longitude': coordinates[0],
          'latitude': coordinates[1],
        };
      } else {
        throw Exception("No coordinates found for the address");
      }
    } else {
      throw Exception("Failed to geocode address: ${response.statusCode}");
    }
  }
}
