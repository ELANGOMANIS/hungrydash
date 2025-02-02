import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../utils/nav_bar.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Dispatch CheckAuthStatus to verify if user is logged in
    BlocProvider.of<AuthBloc>(context).add(CheckAuthStatus());

    // Listen for authentication state changes
    Future.delayed(Duration(seconds: 3), () {
      final state = BlocProvider.of<AuthBloc>(context).state;

      if (state is AuthSuccess) {
        // Navigate to home screen with user data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBarPage(user: state.user)),
        );
      } else {
        // Navigate to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/splash.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
