import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Places Autocomplete with Map',
      home: PlacesAutocompleteScreen(),
    );
  }
}

class PlacesAutocompleteScreen extends StatefulWidget {
  @override
  _PlacesAutocompleteScreenState createState() =>
      _PlacesAutocompleteScreenState();
}

class _PlacesAutocompleteScreenState extends State<PlacesAutocompleteScreen> {
  final String apiKey =
      "AIzaSyCg_GnIlgd4l_04zo6_NJ1AYyHucQgcNP0"; // Replace with your API key
  final TextEditingController _autocompleteController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String selectedCity = 'Islamabad';
  String selectedCountry = 'Pakistan';
  LatLng? selectedLocation;
  LatLng? cityCoordinates;
  GoogleMapController? mapController;
  BitmapDescriptor? customMarkerIcon;

  final List<String> cities = ['Islamabad', 'Lahore', 'Rawalpindi', 'Karachi'];
  final List<String> countries = ['Pakistan'];

  @override
  void initState() {
    super.initState();
    fetchCityCoordinates(selectedCity);
    _loadCustomMarkerIcon();
  }

  Future<void> _loadCustomMarkerIcon() async {
    // Load a custom marker icon from assets
    customMarkerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)), // Adjust size here
      'assets/home_location_marker.png', // Path to your custom marker image
    );
  }

  Future<void> fetchCityCoordinates(String city) async {
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=$city,$selectedCountry&key=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        setState(() {
          cityCoordinates = LatLng(location['lat'], location['lng']);
          mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(cityCoordinates!, 12),
          );
        });
      }
    }
  }

  Future<List<String>> fetchSuggestions(String input) async {
    if (cityCoordinates == null) {
      await fetchCityCoordinates(selectedCity);
    }

    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        "?input=$input"
        "&key=$apiKey"
        "&components=country:pk"
        "&location=${cityCoordinates?.latitude},${cityCoordinates?.longitude}"
        "&radius=50000"; // Bias within 50km radius

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('predictions')) {
        return List<String>.from(
          data['predictions'].map((prediction) => prediction['description']),
        );
      }
    }
    return [];
  }

  Future<void> getPlaceCoordinates(String place) async {
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=$place&key=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        setState(() {
          selectedLocation = LatLng(location['lat'], location['lng']);
          _addressController.text = place;
        });
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(selectedLocation!, 14),
        );
      }
    }
  }

  Future<void> getAddressFromLatLng(LatLng position) async {
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        setState(() {
          _addressController.text = data['results'][0]['formatted_address'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Places Autocomplete with Map")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedCountry,
              items: countries.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: "Select Country",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  selectedCountry = value!;
                  fetchCityCoordinates(selectedCity);
                });
              },
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCity,
              items: cities.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: "Select City",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  selectedCity = value!;
                  fetchCityCoordinates(selectedCity);
                });
              },
            ),
            SizedBox(height: 10),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.length < 3) {
                  return const Iterable<String>.empty();
                }
                return await fetchSuggestions(textEditingValue.text);
              },
              onSelected: (String selection) {
                getPlaceCoordinates(selection);
              },
              fieldViewBuilder: (context, controller, focusNode, onSubmit) {
                _autocompleteController.text = controller.text;
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Search Address',
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _addressController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Selected Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                onTap: (LatLng position) {
                  setState(() {
                    selectedLocation = position;
                    _addressController.clear();
                    getAddressFromLatLng(position);
                  });
                },
                initialCameraPosition: CameraPosition(
                  target: cityCoordinates ?? LatLng(33.6844, 73.0479),
                  zoom: 12,
                ),
                markers: selectedLocation != null
                    ? {
                        Marker(
                          markerId: MarkerId('selected-location'),
                          position: selectedLocation!,
                          draggable: true,
                          onDragEnd: (LatLng newPosition) {
                            setState(() {
                              selectedLocation = newPosition;
                              _addressController.clear();
                              getAddressFromLatLng(newPosition);
                            });
                          },
                          icon:
                              customMarkerIcon ?? // Use custom icon if available
                                  BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor
                                        .hueRed, // Default red color
                                  ),
                        )
                      }
                    : {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
