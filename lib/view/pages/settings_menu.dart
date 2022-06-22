import 'package:flutter/material.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: SettingsMenu());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
            child: ListView(
          children: const [
            ListTile(
              title: Text('Settings'),
            )
          ],
        )),
      ),
    );
  }
}
