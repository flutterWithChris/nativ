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
import 'package:nativ/bloc/profile/profile_bloc.dart';
import 'package:nativ/bloc/settings/preferences.dart';
import 'package:nativ/bloc/settings/theme/bloc/theme_bloc.dart';
import 'package:nativ/bloc/signup/signup_cubit.dart';
import 'package:nativ/data/repositories/auth_repository.dart';
import 'package:nativ/data/repositories/database_repository.dart';
import 'package:nativ/data/repositories/geolocation/geolocation_repository.dart';
import 'package:nativ/data/repositories/storage/storage_repository.dart';
import 'package:nativ/data/routes/routes.dart';
import 'package:nativ/firebase_options.dart';
import 'package:nativ/view/pages/profile/profile_menu.dart';

import 'package:nativ/view/pages/settings/settings_menu.dart';
import 'package:nativ/view/widgets/bottom_nav_bar.dart';
import 'package:nativ/view/widgets/location_searchbar.dart';
import 'package:nativ/view/widgets/main_map.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  Future<void> dotLoad() async => await dotenv.load();
  Future<void> prefsLoad() async => await SharedPrefs().init();
  Future<FirebaseApp> startFire() async => await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Center(
    child: CircularProgressIndicator(),
  ));
  await Future.wait([
    dotLoad(),
    prefsLoad(),
    startFire(),
    initializeDateFormatting(),
  ]);
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
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: _authRepository,
          ),
        ],
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
        RepositoryProvider(
          create: (context) => StorageRepository(),
        ),
        RepositoryProvider(
          create: (context) => DatabaseRepository(),
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
              storageRepository: context.read<StorageRepository>(),
              databaseRepository: context.read<DatabaseRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(
              appBloc: context.read<AppBloc>(),
              databaseRepository: context.read<DatabaseRepository>(),
            )..add(
                LoadProfile(userId: context.read<AppBloc>().state.user.id!),
              ),
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
    ScrollController scrollController = ScrollController();
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Scaffold(
          bottomSheet: StreamBuilder(
            stream: context.read<LocationBloc>().selectedLocation.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return NativListView(
                  scrollController: scrollController,
                );
              } else {
                return Container(
                  height: 1,
                );
              }
            },
          ),
          drawer: Drawer(
            //backgroundColor: Colors.indigo,

            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                children: <Widget>[
                  DrawerHeader(
                    child: Text(
                      user.name!,
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 20),
                    ),
                  ),
                  const LogoutButton(),
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
                    BlocBuilder<LocationBloc, LocationState>(
                        builder: (context, state) {
                      return const MainMap();
                    }),
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

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          context.read<AppBloc>().add(AppLogoutRequest());
        },
        child: Wrap(
          spacing: 10,
          children: const [
            Text('Logout'),
            Icon(Icons.logout_rounded),
          ],
        ));
  }
}

class MainAppBar extends StatefulWidget {
  const MainAppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
      builder: (context, state) {
        return AppBar(
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 24.0),
              child: SizedBox(
                  width: 75,
                  child: FittedBox(
                      child: Opacity(opacity: 0.8, child: ThemeSwitcher()))),
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
