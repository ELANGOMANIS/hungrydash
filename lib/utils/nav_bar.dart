import 'package:flutter/material.dart';
import 'package:hungerdash/screens/home_screen.dart';  // Assuming you already have this
import 'package:hungerdash/data/user_model.dart';        // Assuming you have a UserModel class
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class BottomNavBarPage extends StatefulWidget {
  final UserModel user;

  const BottomNavBarPage({
    Key? key,
    required this.user
  }) : super(key: key);

  @override
  _BottomNavBarPageState createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  late List<Widget> _screens;
  int _selectedIndex = 0; // Track selected index for navigation

  @override
  void initState() {
    super.initState();
    // Initialize the screens list here, now you can access widget.user

    _screens = [
      HomeScreen(user: widget.user), // Home Screen
      HomeScreen(user: widget.user), // Home Screen
      HomeScreen(user: widget.user), // Another instance of Home Screen
      // You can add more screens here, such as a SettingsScreen
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Build a dynamic list of icons with color based on selected index
    final List<Widget> items = [
      Icon(Icons.home, size: 24, color: _selectedIndex == 0 ? Colors.white : Colors.grey),
      Icon(Icons.fastfood, size: 24, color: _selectedIndex == 1 ? Colors.white : Colors.grey),
      Icon(Icons.settings, size: 24, color: _selectedIndex == 2 ? Colors.white : Colors.grey),
    ];

    return Scaffold(
      body: _screens[_selectedIndex], // Show the corresponding screen based on selected index
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex, // Current selected index
        items: items,          // Use the dynamically built list of icons
        height: 50,            // Reduced the height of the nav bar
        color: Colors.white,   // Background color for the bar (unselected items background)
        buttonBackgroundColor: Colors.red, // Background color for the selected icon
        backgroundColor: Colors.transparent, // Background behind the bar
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut, // Animation curve
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
