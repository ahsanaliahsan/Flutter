import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

ThemeData defaultLightTheme = ThemeData(
    colorScheme: ColorScheme.light(
        surface: Color.fromARGB(255, 241, 239, 239),
        primary: Colors.orange,
        primaryContainer: Colors.grey.shade500,
        secondary: Colors.grey.shade200,
        tertiary: Colors.white,
        inversePrimary: Colors.grey.shade900));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: defaultLightTheme,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _selectedUserType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ThaikaTextBox(
                  controller: TextEditingController(),
                  hintText: 'Enter your First Name',
                  labelText: 'First Name',
                  icon: Icons.person,
                  obscureText: false,
                  validator: (value) {
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ThaikaTextBox(
                  controller: TextEditingController(),
                  hintText: 'Enter your Last Name',
                  labelText: 'Last Name',
                  icon: Icons.person,
                  isMultiline: true,
                  obscureText: false,
                  validator: (value) {
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ThaikaDropDown(
                  hintText: "hintText",
                  labelText: "Login",
                  icon: Icons.person,
                  value: _selectedUserType,
                  onChanged: (value) =>
                      setState(() => _selectedUserType = value),
                  items: [
                    'Client',
                    'Contractor',
                    'User',
                    'Admin',
                    'Super Admin',
                    'Mason',
                    'Plumber',
                    'Electrician',
                    'Carpenter'
                  ],
                  required: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ThaikaButton(
                  buttonText: "Register Now",
                  onTap: () {},
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThaikaTextBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData icon;
  final bool enabled;
  final bool isMultiline;
  final bool obscureText;
  final FormFieldValidator<String>? validator;

  const ThaikaTextBox({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.icon,
    this.enabled = true,
    this.isMultiline = false,
    required this.obscureText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 17.0, color: Colors.grey.shade800),
      enabled: enabled,
      maxLines: isMultiline ? 5 : 1, // Set maxLines based on isMultiline
      obscureText: !isMultiline && obscureText, // Only obscure if not multiline
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        labelText: labelText,
        labelStyle:
            TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        floatingLabelStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold), // Bold when floating

        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Colors.orange, size: 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(width: 1.5, color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(width: 1.5, color: Colors.orange.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(width: 2.0, color: Colors.orange.shade600),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText cannot be empty';
        }
        return validator?.call(value);
      },
    );
  }
}

class ThaikaButton extends StatelessWidget {
  final String buttonText;
  final void Function()? onTap;
  final dynamic fontWeight;

  const ThaikaButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade600,
              Colors.orange.shade300,
            ], // Define the gradient colors
            begin:
                Alignment.topLeft, // Define the starting point of the gradient
            end: Alignment
                .bottomRight, // Define the ending point of the gradient
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}

class ThaikaDropDown extends StatelessWidget {
  final String hintText;
  final String labelText;
  final IconData icon;
  final String? value;
  final Function(String?) onChanged;
  final List<String> items;
  final bool required;

  const ThaikaDropDown({
    Key? key,
    required this.hintText,
    required this.labelText,
    required this.icon,
    required this.value,
    required this.onChanged,
    required this.items,
    this.required = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        labelText: labelText,
        labelStyle:
            TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        floatingLabelStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold), // Bold when floating
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Colors.orange, size: 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(width: 1.5, color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(width: 1.5, color: Colors.orange.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(width: 2.0, color: Colors.orange.shade600),
        ),
      ),
      isExpanded: true,
      value: value,
      onChanged: onChanged,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      }).toList(),
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return '$labelText cannot be empty';
        }
        return null;
      },
    );
  }
}
