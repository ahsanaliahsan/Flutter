import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Places Autocomplete with City & Country',
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
      "AIzaSyCg_GnIlgd4l_04zo6_NJ1AYyHucQgcNP0"; // Replace with your actual API key
  final TextEditingController _controller = TextEditingController();
  String selectedCity = 'Islamabad';
  String selectedCountry = 'Pakistan';
  List<String> suggestions = [];
  final FocusNode _focusNode = FocusNode();

  // Predefined cities and countries
  final List<String> cities = ['Islamabad', 'Lahore', 'Rawalpindi', 'Karachi'];
  final List<String> countries = ['Pakistan'];

  Future<List<String>> fetchSuggestions(String input) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&components=country:pk";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('predictions')) {
        return List<String>.from(
          data['predictions']
              .where((prediction) =>
                  prediction['description']
                      .toString()
                      .toLowerCase()
                      .contains(selectedCity.toLowerCase()) &&
                  prediction['description']
                      .toString()
                      .toLowerCase()
                      .contains(selectedCountry.toLowerCase()))
              .map((prediction) => prediction['description']),
        );
      }
    } else {
      print("Error: ${response.statusCode}");
      print("Response: ${response.body}");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Places Autocomplete")),
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
              displayStringForOption: (String option) => option,
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Enter Place Name',
                    border: OutlineInputBorder(),
                  ),
                );
              },
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<String> onSelected,
                  Iterable<String> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 16,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return ListTile(
                            title: Text(option),
                            onTap: () {
                              onSelected(option);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              onSelected: (String selection) {
                print('You selected: $selection');
              },
            ),
          ],
        ),
      ),
    );
  }
}
