import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hungerdash/screens/home_screen.dart';  // Assuming you already have this
import 'package:hungerdash/data/user_model.dart';        // Assuming you have a UserModel class
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../screens/add_cart.dart';
import '../screens/fav_screen.dart';
import '../screens/my_orders.dart';


class BottomNavBarPage extends StatefulWidget {
  final UserModel user;

  const BottomNavBarPage({
    super.key,
    required this.user
  });

  @override
  _BottomNavBarPageState createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  late List<Widget> _screens;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeScreen(user: widget.user), // Home Screen
      FavoriteItemsScreen(userEmail: widget.user.email,user: widget.user), // Home Screen
      AddCartScreen(userEmail: widget.user.email,user: widget.user), // Another instance of Home Screen
      MyOrders(userEmail: widget.user.email,), // Another instance of Home Screen
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
      Icon(Icons.home, size: 24, color: _selectedIndex == 0 ? Colors.white : Colors.grey),
      Icon(Icons.favorite_border, size: 24, color: _selectedIndex == 1 ? Colors.white : Colors.grey),
      Icon(Icons.add_shopping_cart, size: 24, color: _selectedIndex == 2 ? Colors.white : Colors.grey),
      Icon(CupertinoIcons.cube_fill, size: 24, color: _selectedIndex == 3 ? Colors.white : Colors.grey),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        items: items,
        height: 50,
        color: Colors.white,
        buttonBackgroundColor: Colors.red,
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 400),
        animationCurve: Curves.easeInOut,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
