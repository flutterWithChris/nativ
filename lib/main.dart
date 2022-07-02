import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:nativ/bloc/app/app_bloc.dart';
import 'package:nativ/bloc/bottom_nav_bar/bottom_nav_bar_cubit.dart';
import 'package:nativ/bloc/geolocation/bloc/geolocation_bloc.dart';
import 'package:nativ/bloc/location/location_bloc.dart';
import 'package:nativ/bloc/onboarding/onboarding_bloc.dart';
import 'package:nativ/bloc/settings/preferences.dart';
import 'package:nativ/bloc/settings/theme/bloc/theme_bloc.dart';
import 'package:nativ/bloc/signup/signup_cubit.dart';
import 'package:nativ/data/repositories/auth_repository.dart';
import 'package:nativ/data/repositories/database_repository.dart';
import 'package:nativ/data/repositories/geolocation/geolocation_repository.dart';
import 'package:nativ/data/repositories/storage/storage_repository.dart';
import 'package:nativ/data/routes/routes.dart';
import 'package:nativ/firebase_options.dart';
import 'package:nativ/view/pages/profile_menu.dart';
import 'package:nativ/view/pages/settings_menu.dart';
import 'package:nativ/view/widgets/bottom_nav_bar.dart';
import 'package:nativ/view/widgets/location_searchbar.dart';
import 'package:nativ/view/widgets/main_map.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final authRepository = AuthRepository();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Material();
  };
  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository _authRepository;

  const MyApp({
    Key? key,
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: _authRepository,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AppBloc>(
              create: (context) => AppBloc(authRepository: _authRepository),
            ),
            BlocProvider<BottomNavBarCubit>(
              create: (context) => BottomNavBarCubit(),
            ),
          ],
          child: const AppView(),
        ));
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => GeoLocationRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => BottomNavBarCubit(),
          ),
          BlocProvider(
            create: (context) => LocationBloc(),
          ),
          BlocProvider(
            create: (context) => ThemeBloc(),
          ),
          BlocProvider(
            create: (context) => GeolocationBloc(
                geoLocationRepository: context.read<GeoLocationRepository>())
              ..add(LoadGeolocation()),
          ),
          BlocProvider(
            create: (context) => SignupCubit(context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) => OnboardingBloc(
                storageRepository: StorageRepository(),
                databaseRepository: DatabaseRepository()),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return GetMaterialApp(
              theme: state.themeData,
              home: FlowBuilder(
                state: context.select((AppBloc bloc) => bloc.state.status),
                onGeneratePages: onGenerateAppViewPages,
              ),
            );
          },
        ),
      ),
    );
  }
}

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
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Scaffold(
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
          bottomNavigationBar:
              BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
            builder: (context, state) {
              return BottomNavBar(index: state.index);
            },
          ),
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: MainAppBar(),
          ),
          body: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
            builder: (context, state) {
              if (state.bottomNavBarItem == BottomNavBarItem.home) {
                return Stack(
                  children: [
                    const MainMap(),
                    BlocBuilder<LocationBloc, LocationState>(
                      builder: (context, state) {
                        if (state is LocationLoading) {
                          return SlidingUpPanel(
                            controller: panelController,
                            defaultPanelState: PanelState.CLOSED,
                            parallaxEnabled: true,
                            parallaxOffset: 1.0,
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.81,
                            minHeight: 150,
                            panelBuilder: ((sc) => NativListView(
                                  scrollController: sc,
                                )),
                            body: const MainMap(),
                          );
                        }
                        return const MainMap();
                      },
                    ),
                  ],
                );
              } else if (state.bottomNavBarItem == BottomNavBarItem.profile) {
                return const ProfileMenu();
              } else if (state.bottomNavBarItem == BottomNavBarItem.settings) {
                return const SettingsMenu();
              }
              return Container();
            },
          ),
        );
      },
    );
  }
}

class MainAppBar extends StatelessWidget {
  const MainAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
      builder: (context, state) {
        if (state.bottomNavBarItem == BottomNavBarItem.profile) {
          return AppBar(
              actions: [
                TextButton(
                  onPressed: () =>
                      context.read<AppBloc>().add(AppLogoutRequest()),
                  child: Wrap(
                    spacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: const [
                      Text(
                        'Logout',
                      ),
                      Icon(
                        Icons.logout_rounded,
                      ),
                    ],
                  ),
                ),
              ],
              title: PopupMenuButton(
                position: PopupMenuPosition.under,
                child: Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: const [
                    Text('thor_oak'),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
                itemBuilder: (context) {
                  List<PopupMenuItem> menuItems = [
                    const PopupMenuItem(child: Text("thor_in (traveler)")),
                  ];
                  return menuItems;
                },
              )
              //  backgroundColor: Colors.white,
              );
        }
        return AppBar(
          actions: [
            TextButton(
              onPressed: () => context.read<AppBloc>().add(AppLogoutRequest()),
              child: Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: const [
                  Text(
                    'Logout',
                  ),
                  Icon(
                    Icons.logout_rounded,
                  ),
                ],
              ),
            ),
          ],
          title: const Text(
            'Nativ',
          ),
          //  backgroundColor: Colors.white,
        );
      },
    );
  }
}
