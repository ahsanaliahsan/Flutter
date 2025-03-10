import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart'; // For address autocomplete

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions(); // Request location permission before app starts
  runApp(MyApp());
}

Future<void> requestPermissions() async {
  if (await Permission.location.isDenied) {
    await Permission.location.request();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Demo',
      home: MapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? location; // Stores the fetched location
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLocation("Lahore"); // Default location
  }

  Future<void> fetchLocation(String address) async {
    const String apiKey =
        "AIzaSyCg_GnIlgd4l_04zo6_NJ1AYyHucQgcNP0"; // Replace with your Google Maps API key
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == "OK") {
        double lat = data['results'][0]['geometry']['location']['lat'];
        double lng = data['results'][0]['geometry']['location']['lng'];
        setState(() {
          location = LatLng(lat, lng);
        });
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(location!, 12),
        );
      } else {
        print("Error: ${data['status']}");
      }
    } else {
      print("Failed to fetch location");
    }
  }

  Future<List<String>> getPlaceSuggestions(String query) async {
    const String apiKey =
        "AIzaSyCg_GnIlgd4l_04zo6_NJ1AYyHucQgcNP0"; // Replace with your Google Places API key
    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey&types=geocode";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == "OK") {
        List<String> suggestions = [];
        for (var prediction in data['predictions']) {
          suggestions.add(prediction['description']);
        }
        return suggestions;
      } else {
        print("Places API Error: ${data['status']}");
      }
    } else {
      print("Failed to fetch suggestions");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Maps API Example")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TypeAheadField(
              controller: addressController,
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Enter Address',
                    border: OutlineInputBorder(),
                  ),
                );
              },
              suggestionsCallback: (pattern) async {
                return await getPlaceSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSelected: (suggestion) {
                addressController.text = suggestion;
                fetchLocation(suggestion);
              },
            ),
          ),
          Expanded(
            child: location == null
                ? Center(child: CircularProgressIndicator()) // Show loading
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: location!,
                      zoom: 12,
                    ),
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    markers: {
                      Marker(
                        markerId: MarkerId("selected-location"),
                        position: location!,
                        infoWindow: InfoWindow(title: "Selected Location"),
                      ),
                    },
                    onTap: (LatLng latLng) {
                      setState(() {
                        location = latLng;
                      });
                      mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(latLng, 12),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (location != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Selected Location: $location"),
              ),
            );
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
