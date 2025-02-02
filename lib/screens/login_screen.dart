import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';  // Import the loading animation package
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../data/user_model.dart';
import '../utils/nav_bar.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: _LoginScreenBody(),
    );
  }
}

class _LoginScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          final user = state.user;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavBarPage(user: state.user)),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signup Failed')),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Main content of your page
            Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/delivery.png',
                        height: screenHeight * 0.2,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Get Ready to Go ?',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: OutlinedButton(
                          onPressed: () =>
                              context.read<AuthBloc>().add(SignInWithGoogle()),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey),
                            padding:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google.png',
                                height: 20,
                              ),
                              SizedBox(width: 10),
                              const Text(
                                "Continue with Google",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
            // Overlay the loading animation when in AuthLoading state
            if (context.watch<AuthBloc>().state is AuthLoading)
              Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  size: 30,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
