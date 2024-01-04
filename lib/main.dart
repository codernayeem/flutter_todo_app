import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_todo_app/firebase_options.dart';
import 'package:flutter_todo_app/providers/todo_provider.dart';
import 'package:flutter_todo_app/screens/phone_auth.dart';
import 'package:flutter_todo_app/screens/sign_up_page.dart';
import 'screens/home_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ToDoProvider()),
      ],
      child: MaterialApp(
        title: 'ToDo App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(0, 137, 96, 72),
              brightness: Brightness.light),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(0, 137, 96, 72),
              brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
        routes: {
          "signUp": (context) => const SignUpPage(),
          "phoneAuth": (context) => const PhoneAuthPage(),
        },
      ),
    );
  }
}
