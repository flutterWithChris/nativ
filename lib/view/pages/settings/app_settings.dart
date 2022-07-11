import 'package:flutter/material.dart';
import 'package:nativ/main.dart';
import 'package:nativ/view/pages/settings/settings_menu.dart';
import 'package:nativ/view/widgets/bottom_nav_bar.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50.0), child: MainAppBar()),
      bottomNavigationBar: BottomNavBar(
        index: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ListTile(
                  title: Text(
                    'App Settings',
                    style: TextStyle(fontSize: 24),
                  ),
                  subtitle: Text(''),
                ),
                ListTile(
                  title: Text(
                    'Brightness',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Light / Dark Mode'),
                  trailing: SizedBox(
                      height: 40, child: FittedBox(child: ThemeSwitcher())),
                ),
                ListTile(
                  title: Text('Brightness'),
                  subtitle: Text('Light / Dark Mode'),
                  trailing: SizedBox(
                      height: 40, child: FittedBox(child: ThemeSwitcher())),
                ),
              ]),
        ),
      ),
    );
  }
}
