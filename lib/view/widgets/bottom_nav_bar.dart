import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nativ/bloc/bottom_nav_bar/bottom_nav_bar_cubit.dart';
import 'package:nativ/bloc/settings/preferences.dart';
import 'package:nativ/bloc/settings/theme/bloc/theme_bloc.dart';

class BottomNavBar extends StatefulWidget {
  int index;
  BottomNavBar({required this.index, Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final TextStyle _textStyle = const TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
      fontStyle: FontStyle.italic);
  @override
  Widget build(BuildContext context) {
    const menuItemList = <NavigationDestination>[
      NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      NavigationDestination(
          icon: Icon(FontAwesomeIcons.compass), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
    ];

    BottomNavBarCubit bottomNavBarBloc =
        BlocProvider.of<BottomNavBarCubit>(context);

    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (previous, current) => previous.themeData != current.themeData,
      builder: (context, state) {
        if (SharedPrefs().getThemeIndex == 0) {
          return NavigationBarTheme(
              data: NavigationBarThemeData(
                  labelBehavior:
                      NavigationDestinationLabelBehavior.onlyShowSelected,
                  height: 70,
                  indicatorColor: Colors.white.withOpacity(0.5),
                  labelTextStyle: MaterialStateProperty.all(const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold))),
              child: NavigationBar(
                animationDuration:
                    const Duration(seconds: 1, milliseconds: 618),
                backgroundColor: const Color(0xFFf3f6f2),
                destinations: menuItemList,
                selectedIndex: widget.index,
                onDestinationSelected: (index) {
                  if (index == 0) {
                    bottomNavBarBloc.getNavBarItem(BottomNavBarItem.profile);
                  } else if (index == 1) {
                    bottomNavBarBloc.getNavBarItem(BottomNavBarItem.home);
                  } else if (index == 2) {
                    bottomNavBarBloc.getNavBarItem(BottomNavBarItem.settings);
                  }
                },
                elevation: 16.0,
              ));
        } else {
          return NavigationBarTheme(
              data: NavigationBarThemeData(
                  labelBehavior:
                      NavigationDestinationLabelBehavior.onlyShowSelected,
                  height: 70,
                  indicatorColor: const Color(0xff93A3AB),
                  iconTheme: const MaterialStatePropertyAll(IconThemeData(
                    color: Colors.white,
                  )),
                  labelTextStyle: MaterialStateProperty.all(const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
              child: NavigationBar(
                animationDuration:
                    const Duration(seconds: 1, milliseconds: 618),
                backgroundColor: const Color(0xff515A5E).withAlpha(255),
                destinations: menuItemList,
                selectedIndex: widget.index,
                onDestinationSelected: (index) {
                  if (index == 0) {
                    bottomNavBarBloc.getNavBarItem(BottomNavBarItem.profile);
                  } else if (index == 1) {
                    bottomNavBarBloc.getNavBarItem(BottomNavBarItem.home);
                  } else if (index == 2) {
                    bottomNavBarBloc.getNavBarItem(BottomNavBarItem.settings);
                  }
                },
                elevation: 16.0,
              ));
        }
      },
    );
  }
}
