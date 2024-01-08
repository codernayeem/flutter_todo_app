import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // String _layout = 'Standard';
  final String _credit = 'Made By @codernayeem';
  final Uri _url = Uri.parse('https://github.com/codernayeem');

  @override
  void initState() {
    super.initState();
    // _loadPreferences();
  }

  // void _loadPreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _layout = prefs.getString('layout') ?? 'Standard';
  //   });
  // }

  // void _savePreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('layout', _layout);
  // }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode =
        ThemeProvider.themeOf(context).data.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Row(
                children: [
                  Icon(darkMode ? Icons.dark_mode : Icons.light_mode),
                  const SizedBox(width: 14),
                  const Text('Dark Theme'),
                ],
              ),
              value: darkMode,
              onChanged: (value) {
                setState(() {
                  if (darkMode) {
                    ThemeProvider.controllerOf(context).setTheme("light");
                  } else {
                    ThemeProvider.controllerOf(context).setTheme("dark");
                  }
                });
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(_credit),
              onTap: _launchUrl,
            ),
          ],
        ),
      ),
    );
  }
}
