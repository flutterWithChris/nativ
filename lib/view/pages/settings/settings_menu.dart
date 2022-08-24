import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nativ/bloc/settings/preferences.dart';
import 'package:nativ/bloc/settings/theme/bloc/theme_bloc.dart';
import 'package:nativ/view/pages/settings/app_settings.dart';
import 'package:nativ/view/themes/app_themes.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: SettingsMenu());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SettingsList(
      darkTheme: SettingsThemeData(
          titleTextColor: Colors.white,
          settingsSectionBackground: Colors.cyan,
          settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          settingsTileTextColor: Colors.white),
      lightTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          settingsSectionBackground: const Color(0xFFb3bccc)),
      sections: [
        SettingsSection(title: const Text('Account'), tiles: [
          SettingsTile.navigation(
              leading: const Icon(Icons.email_rounded),
              title: const Text('Email')),
          SettingsTile.navigation(
              leading: const Icon(Icons.phone),
              title: const Text('Phone Number')),
          SettingsTile.navigation(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Sign Out')),
        ])
      ],
    ));
  }
}

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ThemeBloc>(),
      child: DayNightSwitcher(
        isDarkModeEnabled: SharedPrefs().getThemeIndex == 0 ? false : true,
        onStateChanged: (isDarkModeEnabled) async {
          isDarkModeEnabled
              ? BlocProvider.of<ThemeBloc>(context)
                  .add(const ThemeChanged(theme: AppTheme.Dark))
              : BlocProvider.of<ThemeBloc>(context)
                  .add(const ThemeChanged(theme: AppTheme.Light));
        },
      ),
    );
  }
}

class SettingsMenuItem extends StatelessWidget {
  final IconData leadingIcon;
  final String label;
  final IconData trailingIcon;
  const SettingsMenuItem({
    Key? key,
    required this.leadingIcon,
    required this.label,
    required this.trailingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          onTap: () {
            Get.to(() => const AppSettings());
          },
          minVerticalPadding: 25,
          leading: SizedBox(
            height: 42,
            child: Icon(
              leadingIcon,
            ),
          ),
          title: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          trailing: SizedBox(height: 42, child: Icon(trailingIcon)),
        ),
        const Divider(),
      ],
    );
  }
}
