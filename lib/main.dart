import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';  // Import Bloc package
import 'package:hungerdash/screens/login_screen.dart';
import 'package:hungerdash/screens/home_screen.dart';
import 'package:hungerdash/screens/splash_screen.dart';
import 'package:hungerdash/utils/nav_bar.dart';
import 'package:hungerdash/utils/theme.dart';

import 'bloc/auth_bloc.dart';  // Import your AuthBloc
import 'bloc/auth_event.dart';
import 'data/user_model.dart';
import 'database/localdatabase.dart';  // Import UserModel



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final DatabaseUser dbHelper = DatabaseUser();

  await dbHelper.backupDatabase();


  final db = DatabaseUser();
  await db.database;
  runApp(
    BlocProvider(
      create: (context) => AuthBloc()..add(CheckAuthStatus()), // Auto-check user session
      child: MyApp(),
    ),
  );
}
//enga

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(  // Provide AuthBloc here
      create: (context) => AuthBloc(),  // Initialize the AuthBloc
      child: MaterialApp(
        title: 'HungerDash',
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme.copyWith(  // Use your custom light theme here
          textTheme: GoogleFonts.latoTextTheme(AppThemes.lightTheme.textTheme),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/home': (context) {
            final UserModel user = ModalRoute.of(context)!.settings.arguments as UserModel;
            return BottomNavBarPage(user: user);
          },
        },
      ),
    );
  }
}


