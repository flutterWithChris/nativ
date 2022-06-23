import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nativ/bloc/settings/display/display_mode_cubit.dart';

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
          children: [
            BlocProvider(
              create: (context) => DisplayModeCubit(),
              child: BlocConsumer<DisplayModeCubit, DisplayModeState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                buildWhen: (previous, current) =>
                    previous.displayMode != current.displayMode,
                builder: (context, state) {
                  if (state.displayMode == DisplayMode.lightMode) {
                    return Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Switch(
                            value: true,
                            onChanged: (switched) {
                              state.copyWith(displayMode: DisplayMode.darkMode);
                            }),
                        const Icon(
                          Icons.light_mode_outlined,
                          size: 35,
                        ),
                      ],
                    );
                  } else {
                    return Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Switch(
                            value: true,
                            onChanged: (switched) {
                              state.copyWith(
                                  displayMode: DisplayMode.lightMode);
                            }),
                        const Icon(
                          Icons.light_mode_outlined,
                          size: 35,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            const SettingsMenuItem(
              leadingIcon: Icon(Icons.person),
              label: 'Account Info',
              trailingIcon: Icon(Icons.arrow_forward),
            ),
            const SettingsMenuItem(
              leadingIcon: Icon(Icons.app_settings_alt_outlined),
              label: 'App Settings',
              trailingIcon: Icon(Icons.arrow_forward),
            ),
            const SettingsMenuItem(
              leadingIcon: Icon(Icons.question_mark_rounded),
              label: 'Support & Help',
              trailingIcon: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsMenuItem extends StatelessWidget {
  final Icon leadingIcon;
  final String label;
  final Icon trailingIcon;
  const SettingsMenuItem({
    Key? key,
    required this.leadingIcon,
    required this.label,
    required this.trailingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          minVerticalPadding: 25,
          leading: leadingIcon,
          title: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          trailing: trailingIcon,
        ),
        const Divider(),
      ],
    );
  }
}
