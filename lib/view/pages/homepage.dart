import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:nativ/bloc/bottom_nav_bar/bottom_nav_bar_cubit.dart';
import 'package:nativ/view/pages/profile/profile_menu.dart';
import 'package:nativ/view/pages/settings/settings_menu.dart';
import 'package:nativ/view/widgets/bottom_nav_bar.dart';
import 'package:nativ/view/widgets/main_map.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../bloc/app/app_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Page page() => const MaterialPage<void>(child: HomeScreen());

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentRoute = Get.currentRoute;
  final screens = [
    const HomeScreen(),
    const ProfileScreen(),
    const SettingsMenu(),
  ];

  @override
  Widget build(BuildContext context) {
    final PanelController panelController = PanelController();
    final ScrollController scrollController = ScrollController();
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      // bottomSheet: NativListView(scrollController: scrollController),
      drawer: Drawer(
        //backgroundColor: Colors.indigo,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: const <Widget>[
              ThemeSwitcher(),
              DrawerHeader(
                child: Text(
                  'Name',
                  style: TextStyle(color: Colors.black87, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          return BottomNavBar(index: state.index);
        },
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                context.read<AppBloc>().add(AppLogoutRequest());
              },
              icon: const Icon(
                Icons.exit_to_app,
              )),
        ],
        title: const Text(
          'Nativ',
        ),
        //  backgroundColor: Colors.white,
      ),
      body: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          if (state.bottomNavBarItem == BottomNavBarItem.home) {
            return const MainMap();
          } else if (state.bottomNavBarItem == BottomNavBarItem.profile) {
            return const ProfileMenu();
          } else if (state.bottomNavBarItem == BottomNavBarItem.settings) {
            return const SettingsMenu();
          }
          return Container();
        },
      ),
    );
  }
}
