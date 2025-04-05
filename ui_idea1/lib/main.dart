import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(MyMenuApp());

class MyMenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyMenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyMenuScreen extends StatefulWidget {
  @override
  _MyMenuScreenState createState() => _MyMenuScreenState();
}

class _MyMenuScreenState extends State<MyMenuScreen> {
  bool isSilentMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // SVG Background
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/orange_waves_smooth.svg',
              fit: BoxFit.fill,
            ),
          ),
          // Foreground UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white),
                      Text(
                        'My Menu',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Icon(Icons.help_outline, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Cards
                  MenuCard(
                    title: '\$340.50',
                    subtitle: 'Earnings this week',
                    onTap: () {},
                  ),
                  MenuCard(
                    title: 'Profile',
                    subtitle: 'Edit your profile',
                    onTap: () {},
                  ),
                  MenuCard(
                    title: 'Account',
                    subtitle: 'Edit your account',
                    onTap: () {},
                  ),
                  SizedBox(height: 20),
                  // Silent Mode
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.notifications_off, color: Colors.white),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Silent Mode\nYour notifications are silent',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Switch(
                          value: isSilentMode,
                          onChanged: (val) {
                            setState(() {
                              isSilentMode = val;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text('Logout'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const MenuCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
