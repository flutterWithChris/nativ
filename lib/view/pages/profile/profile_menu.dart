import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:nativ/bloc/profile/profile_bloc.dart';
import 'package:nativ/bloc/settings/preferences.dart';
import 'package:nativ/bloc/settings/theme/bloc/theme_bloc.dart';
import 'package:nativ/data/model/user.dart';
import 'package:nativ/view/pages/profile/connect_page.dart';
import 'package:nativ/view/screens/chat/chat_screen.dart';

class ProfileMenu extends StatefulWidget {
  const ProfileMenu({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: ProfileMenu());

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  var themeIndex;

  getThemeState() async {
    themeIndex = SharedPrefs().getThemeIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ProfileBloc>(),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ProfileLoaded) {
            return BlocProvider.value(
              value: context.read<ThemeBloc>(),
              child: SafeArea(
                child: Scaffold(
                  body: ListView(
                    shrinkWrap: true,
                    children: [
                      // * Header Image
                      AspectRatio(
                        aspectRatio: 1.618 / 1,
                        child: Image.network(
                          'http://img1.wikia.nocookie.net/__cb20121227125326/lotr/images/1/16/Thorin_2.jpg',
                          alignment: Alignment.topCenter,
                          //   isAntiAlias: true,
                          // filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // * Main Content
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                MainProfileInfo(
                                    name: state.user.name!,
                                    location: state.user.location!,
                                    bio: state.user.bio!),
                                const Padding(
                                  padding: EdgeInsets.only(right: 18, top: 8.0),
                                  child: ProfileIcon(),
                                ),
                              ],
                            ),
                            const MySpecialties(),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: PublicReviews(),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: MyTrips(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('Something Went Wrong...'),
            );
          }
        },
      ),
    );
  }
}

class PublicReviews extends StatelessWidget {
  const PublicReviews({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FractionallySizedBox(
        widthFactor: 0.90, child: ReviewCarousel());
  }
}

class MySpecialties extends StatelessWidget {
  const MySpecialties({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const CircularProgressIndicator();
        }
        if (state is ProfileLoaded) {
          return SizedBox(
            height: 175,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, bottom: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('My Specialties:',
                            style: Theme.of(context).textTheme.titleLarge!),
                      ),
                    ),
                    Expanded(
                      child: InfiniteCarousel.builder(
                        velocityFactor: 0.5,
                        itemCount: 5,
                        itemExtent: 120,
                        itemBuilder: (context, itemIndex, realIndex) {
                          List<SpecialtyIcon> specialtyIcons = [
                            const SpecialtyIcon(
                                icon: FontAwesomeIcons.utensils,
                                label: 'Local Food'),
                            const SpecialtyIcon(
                                icon: FontAwesomeIcons.fish, label: 'Wildlife'),
                            const SpecialtyIcon(
                                icon: FontAwesomeIcons.masksTheater,
                                label: 'Entertainment'),
                            const SpecialtyIcon(
                                icon: FontAwesomeIcons.map,
                                label: 'Navigation'),
                            const SpecialtyIcon(
                                icon: FontAwesomeIcons.tree, label: 'Nature'),
                          ];
                          return specialtyIcons[itemIndex];
                          return Container();
                        },
                        //crossAxisAlignment: WrapCrossAlignment.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(
          child: Text('Something Went Wrong...'),
        );
      },
    );
  }
}

class MyTrips extends StatelessWidget {
  const MyTrips({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const CircularProgressIndicator();
        }
        if (state is ProfileLoaded) {
          User currentUser = state.user;
          return Card(
            color: const Color(0xFFbb92cb),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Align(
                //alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Center(
                        child: Text(
                          'Places I\'ve traveled:',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 12.0,
                      children: [
                        for (int i = 0;
                            i < currentUser.visitedPlaces!.length;
                            i++)
                          Chip(
                            visualDensity: VisualDensity.compact,
                            labelStyle: const TextStyle(color: Colors.white),
                            backgroundColor: const Color.fromARGB(255, 5, 4, 12)
                                .withOpacity(0.9),
                            label: Text(currentUser.visitedPlaces![i]),
                            avatar: const Icon(
                              FontAwesomeIcons.earthAmericas,
                              size: 18,
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(
          child: Text('Something Went Wrong...'),
        );
      },
    );
  }
}

class SpecialtyIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  const SpecialtyIcon({
    required this.icon,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 115,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewCarousel extends StatelessWidget {
  const ReviewCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(children: [
          const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
                'https://bustickets.com/wp-content/uploads/2019/09/solo-travel-backpack-tips.jpg'),
          ),
          const SizedBox(
            width: 15,
          ),
          Flexible(
            child: Text(
              '“Thorin is the BEST nativ around. He took us to incredible & authentic restaurants & guided an awesome hike.” \n -Jane Walenda, Traveler',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.black87),
            ),
          )
        ]),
      ),
    );
  }
}

class MainProfileInfo extends StatelessWidget {
  final String name, bio, location;
  const MainProfileInfo({
    required this.name,
    required this.bio,
    required this.location,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //visualDensity: VisualDensity.comfortable,
      //leading: ProfileIcon(),
      title: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        children: [
          // * Name Header
          Text(
            name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: Colors.lightBlueAccent,
            size: 20,
          )
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    const Icon(
                      FontAwesomeIcons.mapPin,
                      size: 14,
                    ),
                    Text(location),
                  ],
                ),
                const SizedBox(
                  height: 25,
                  child: FittedBox(
                    child: Chip(
                      backgroundColor: Colors.lightBlue,
                      label: Text(
                        'Top Rated',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                )
              ]),
          const SizedBox(
            height: 5,
          ),
          Text(
            bio,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const ConnectPage());
                  },
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      fixedSize:
                          MaterialStateProperty.all(const Size(360, 42))),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: const [
                      Text(
                        'Connect ',
                      ),
                      Icon(
                        FontAwesomeIcons.connectdevelop,
                        size: 22,
                      )
                    ],
                  )),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                style: Theme.of(context).outlinedButtonTheme.style,
                label: const Text(
                  'Message Me',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Get.to(() => const ChatScreen());
                },
                icon: const Icon(
                  FontAwesomeIcons.paperPlane,
                  size: 16,
                ),
              ),
              SizedBox(
                child: Wrap(spacing: 20, children: const [
                  Icon(
                    FontAwesomeIcons.instagram,
                  ),
                  Icon(
                    FontAwesomeIcons.facebook,
                    color: Color(0xFF4267B2),
                  ),
                  Icon(
                    FontAwesomeIcons.twitter,
                    color: Color(0xFF1DA1F2),
                  ),
                ]),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 30.0,
      backgroundImage: NetworkImage(
        'https://www.zbrushcentral.com/uploads/default/original/4X/7/9/6/7966865da1c1203fd5250ab05bb1fc00ba8133e9.jpeg',
      ),
    );
  }
}
