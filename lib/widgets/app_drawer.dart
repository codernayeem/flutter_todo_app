import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/services/auth_services.dart';
import 'package:theme_provider/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  final User? user;
  final AuthClass authClass = AuthClass();

  AppDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              user!.displayName!,
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
            accountEmail: (user!.email == null)
                ? null
                : Text(
                    user!.email!,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.background),
                  ),
            currentAccountPicture: user!.photoURL == null
                ? null
                : Stack(
                    children: [
                      ClipOval(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.blue,
                                Color.fromARGB(255, 44, 137, 236),
                                Colors.blue,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: user!.photoURL!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          Container(
            child: ThemeProvider.themeOf(context).data.brightness ==
                    Brightness.dark
                ? ListTile(
                    title: const Text('Use Light Theme'),
                    leading: const Icon(Icons.light_mode),
                    onTap: () {
                      ThemeProvider.controllerOf(context).setTheme("light");
                      Navigator.pop(context);
                    },
                  )
                : ListTile(
                    title: const Text('Use Dark Theme'),
                    leading: const Icon(Icons.dark_mode),
                    onTap: () {
                      ThemeProvider.controllerOf(context).setTheme("dark");
                      Navigator.pop(context);
                    },
                  ),
          ),
          const Divider(),
          ListTile(
            title: const Text('LogOut'),
            leading: const Icon(Icons.logout),
            onTap: () {
              authClass.handleSignOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
