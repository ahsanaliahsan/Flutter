import 'package:flutter/material.dart';

void main() {
  runApp(const FontShowcaseApp());
}

class FontShowcaseApp extends StatelessWidget {
  const FontShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Font Color Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Poppins',
        colorScheme: const ColorScheme.light(
          primary: Colors.orange,
          secondary: Colors.grey,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.dark(
          primary: Colors.deepOrange,
          secondary: Colors.grey,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const FontShowcasePage(),
    );
  }
}

class FontShowcasePage extends StatelessWidget {
  const FontShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sizes = List.generate(15, (i) => 8.0 + (i * 2)); // 8 to 36 step 2

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🟧 Orange Section: white, black, gray fonts
            SectionBlock(
              title: 'Orange Background - White, Black, Gray Fonts',
              backgroundColor: Colors.orange,
              textStyles: [
                (size) => TextStyle(fontSize: size, color: Colors.white),
                (size) => TextStyle(fontSize: size, color: Colors.black),
                (size) =>
                    TextStyle(fontSize: size, color: Colors.grey.shade300),
              ],
            ),

            // ⚪ Gray Section: white, black, orange fonts
            SectionBlock(
              title: 'Gray Background - White, Black, Orange Fonts',
              backgroundColor: Colors.grey.shade800,
              textStyles: [
                (size) => TextStyle(fontSize: size, color: Colors.white),
                (size) => TextStyle(fontSize: size, color: Colors.black),
                (size) => TextStyle(fontSize: size, color: Colors.orange),
              ],
            ),

            // ⚫ Black Section: white, orange, gray fonts
            SectionBlock(
              title: 'Black Background - White, Orange, Gray Fonts',
              backgroundColor: Colors.black,
              textStyles: [
                (size) => TextStyle(fontSize: size, color: Colors.white),
                (size) => TextStyle(fontSize: size, color: Colors.orange),
                (size) =>
                    TextStyle(fontSize: size, color: Colors.grey.shade400),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SectionBlock extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final List<TextStyle Function(double)> textStyles;

  const SectionBlock({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.textStyles,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = List.generate(15, (i) => 8.0 + (i * 2)); // 8 to 36 step 2

    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...sizes.map((size) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: textStyles
                  .map((styleFn) => Text(
                        'Size $size',
                        style: styleFn(size),
                      ))
                  .toList())),
        ],
      ),
    );
  }
}
