import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungerdash/bloc/favorite/favorite_bloc.dart';
import 'package:hungerdash/screens/splash_screen.dart';
import 'package:hungerdash/utils/nav_bar.dart';
import 'package:hungerdash/utils/theme.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/cart/cart_bloc.dart';
import 'bloc/orders/order_bloc.dart';
import 'data/user_model.dart';
import 'database/localdatabase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final DatabaseUser dbHelper = DatabaseUser();

  await dbHelper.backupDatabase();

  final db = DatabaseUser();
  await db.database;
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(CheckAuthStatus()), // Auto-check user session
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        ),
        BlocProvider(
          create: (context) => FavoriteBloc(DatabaseUser()), // Pass DatabaseUser instance
        ),
        BlocProvider(
          create: (context) => OrderBloc(DatabaseUser()), // Pass DatabaseUser instance
        ),

      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HungerDash',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme.copyWith(
        textTheme: GoogleFonts.latoTextTheme(AppThemes.lightTheme.textTheme),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) {
          final UserModel user = ModalRoute.of(context)!.settings.arguments as UserModel;
          return BottomNavBarPage(user: user);
        },
      },
    );
  }
}