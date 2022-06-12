import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nativ/bloc/bottom_nav_bar/bottom_nav_bar_cubit.dart';

class BottomNavBar extends StatefulWidget {
  int index;
  BottomNavBar({required this.index, Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    const menuItemList = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
    ];

    BottomNavBarCubit bottomNavBarBloc =
        BlocProvider.of<BottomNavBarCubit>(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      items: menuItemList,
      currentIndex: widget.index,
      onTap: (index) {
        if (index == 0) {
          bottomNavBarBloc.getNavBarItem(BottomNavBarItem.home);
        } else if (index == 1) {
          bottomNavBarBloc.getNavBarItem(BottomNavBarItem.profile);
        } else if (index == 2) {
          bottomNavBarBloc.getNavBarItem(BottomNavBarItem.settings);
        }
      },
      elevation: 16.0,
      showUnselectedLabels: true,
      unselectedItemColor: Colors.black38,
      selectedItemColor: Colors.black87,
    );
  }
}
