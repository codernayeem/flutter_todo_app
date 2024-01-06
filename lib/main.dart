import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_todo_app/firebase_options.dart';
import 'package:flutter_todo_app/providers/category_provider.dart';
import 'package:flutter_todo_app/providers/todo_provider.dart';
import 'package:flutter_todo_app/screens/phone_auth.dart';
import 'package:flutter_todo_app/screens/sign_up_page.dart';
import 'screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

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
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
      ],
      child: ThemeProvider(
        saveThemesOnChange: true,
        loadThemeOnInit: true,
        themes: [
          AppTheme(
            id: "light",
            description: "Light Theme",
            data: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color.fromARGB(255, 39, 117, 243),
                  brightness: Brightness.light),
              useMaterial3: true,
            ),
          ),
          AppTheme(
            id: "dark",
            description: "Dark Theme",
            data: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color.fromARGB(255, 7, 167, 241),
                  brightness: Brightness.dark),
              useMaterial3: true,
            ),
          ),
        ],
        child: ThemeConsumer(
          child: Builder(
            builder: (themeContext) => MaterialApp(
              title: 'ToDo App',
              debugShowCheckedModeBanner: false,
              theme: ThemeProvider.themeOf(themeContext).data,
              home: const MyHomePage(),
              routes: {
                "signUp": (context) => const SignUpPage(),
                "phoneAuth": (context) => const PhoneAuthPage(),
              },
            ),
          ),
        ),
      ),
    );
  }
}
