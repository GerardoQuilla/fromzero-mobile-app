import 'package:flutter/material.dart';
import 'package:fromzero_app/prefs/authProvider.dart';
import 'package:fromzero_app/views/LoginViews/Inicio.dart';
import 'package:provider/provider.dart';
import 'navbar.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context)=>AuthProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const AuthHandler(),
        ),
    );
  }
}

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return authProvider.isLoggedIn?Navbar():GetStartedScreen();
  }
}
