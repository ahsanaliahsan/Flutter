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
      title: 'Places Autocomplete Demo',
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
  List<String> suggestions = [];

  Future<void> fetchSuggestions(String input) async {
    final String url = "https://places.googleapis.com/v1/places:autocomplete";

    final Map<String, dynamic> requestBody = {
      "input": input,
      "locationBias": {
        "circle": {
          "center": {
            "latitude": 37.76999,
            "longitude": -122.44696,
          },
          "radius": 500.0,
        },
      },
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': apiKey,
        'X-Goog-FieldMask': 'suggestions.placePrediction.text',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print("API Response: $data"); // Debug the response
      if (data.containsKey('suggestions')) {
        setState(() {
          suggestions = List<String>.from(
            data['suggestions'].map((suggestion) =>
                suggestion['placePrediction']['text'] as String),
          );
        });
      } else {
        print("No suggestions found");
      }
    } else {
      print("Error: ${response.statusCode}");
      print("Response: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Places Autocomplete")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Enter Place Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  fetchSuggestions(value);
                } else {
                  setState(() {
                    suggestions = [];
                  });
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(suggestions[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
