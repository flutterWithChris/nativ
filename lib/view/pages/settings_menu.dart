import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nativ/bloc/settings/preferences.dart';
import 'package:nativ/bloc/settings/theme/bloc/theme_bloc.dart';
import 'package:nativ/view/themes/app_themes.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: SettingsMenu());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            ThemeSwitcher(),
            SettingsMenuItem(
              leadingIcon: Icons.person,
              label: 'Account Info',
              trailingIcon: Icons.arrow_forward,
            ),
            SettingsMenuItem(
              leadingIcon: Icons.app_settings_alt_outlined,
              label: 'App Settings',
              trailingIcon: Icons.arrow_forward,
            ),
            SettingsMenuItem(
              leadingIcon: Icons.question_mark_rounded,
              label: 'Support & Help',
              trailingIcon: Icons.arrow_forward,
            ),
          ],
        ),
      ),
    );
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
    return BlocProvider.value(
      value: context.read<ThemeBloc>(),
      child: Column(
        children: [
          BlocBuilder<ThemeBloc, ThemeState>(
            buildWhen: (previous, current) =>
                previous.themeData != current.themeData,
            builder: (context, state) {
              if (state.themeData == ThemeData.light()) {
                return ListTile(
                  minVerticalPadding: 25,
                  leading: Icon(
                    leadingIcon,
                  ),
                  title: Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(trailingIcon),
                );
              } else {
                return ListTile(
                  minVerticalPadding: 25,
                  leading: SizedBox(
                    height: double.infinity,
                    child: Icon(
                      leadingIcon,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  trailing: SizedBox(
                      height: double.infinity,
                      child: (Icon(trailingIcon, color: Colors.white))),
                );
              }
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
