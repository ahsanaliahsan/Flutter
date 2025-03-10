import 'dart:convert';
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
  final TextEditingController _controller = TextEditingController();
  String selectedCity = 'Islamabad';
  String selectedCountry = 'Pakistan';
  final FocusNode _focusNode = FocusNode();
  LatLng? selectedLocation;
  LatLng? cityCoordinates;
  GoogleMapController? mapController;

  final List<String> cities = ['Islamabad', 'Lahore', 'Rawalpindi', 'Karachi'];
  final List<String> countries = ['Pakistan'];

  // Fetch coordinates for the selected city
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
        });
      }
    } else {
      print("Error fetching city coordinates: ${response.body}");
    }
  }

  // Fetch autocomplete suggestions based on input, city, and country
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
    } else {
      print("Error fetching suggestions: ${response.body}");
    }
    return [];
  }

  Future<void> getPlaceCoordinates(String place) async {
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=$place&key=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        setState(() {
          selectedLocation = LatLng(location['lat'], location['lng']);
        });
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(selectedLocation!, 14),
        );
      }
    } else {
      print("Error fetching place coordinates: ${response.body}");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCityCoordinates(selectedCity); // Fetch initial coordinates
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Places Autocomplete with Map")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Country Dropdown
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

            // City Dropdown
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

            // Autocomplete TextField
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.length < 3) {
                  return const Iterable<String>.empty();
                }
                return await fetchSuggestions(textEditingValue.text);
              },
              fieldViewBuilder: (context, textEditingController, focusNode,
                  onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Enter Place Name',
                    border: OutlineInputBorder(),
                  ),
                );
              },
              onSelected: (String selection) {
                getPlaceCoordinates(selection);
              },
            ),
            SizedBox(height: 10),

            // Google Map Display
            Expanded(
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
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
