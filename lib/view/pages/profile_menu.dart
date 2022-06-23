import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nativ/bloc/app/app_bloc.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: ProfileMenu());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            // * Header Image
            AspectRatio(
              aspectRatio: 1.91 / 1,
              child: Image.network(
                'https://static.euronews.com/articles/stories/06/25/84/50/1200x675_cmsv2_f71b6679-918e-5672-8b87-8f3e17af759e-6258450.jpg',
                fit: BoxFit.cover,
              ),
            ),

            // * Main Content
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: const [
                      MainProfileInfo(),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: ProfileIcon(),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: PublicReviews(),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: MySpecialties(),
                  )
                ],
              ),
            ),
          ],
        ),
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
    return Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: const [
      Icon(
        FontAwesomeIcons.chevronLeft,
        color: Colors.black38,
      ),
      FractionallySizedBox(widthFactor: 0.80, child: ReviewCarousel()),
      Icon(
        FontAwesomeIcons.chevronRight,
        color: Colors.black38,
      ),
    ]);
  }
}

class MySpecialties extends StatelessWidget {
  const MySpecialties({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //    transformAlignment: Alignment.center,
      alignment: Alignment.center,
      width: 400,
      height: 275,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'My Specialties',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Wrap(spacing: 15,
                // crossAxisAlignment: WrapCrossAlignment.center,
                children: const [
                  SpecialtyIcon(
                    icon: FontAwesomeIcons.utensils,
                    label: 'Food',
                  ),
                  SpecialtyIcon(
                    icon: FontAwesomeIcons.trainTram,
                    label: 'Public Transport',
                  ),
                  SpecialtyIcon(
                    icon: FontAwesomeIcons.ticket,
                    label: 'Entertainment',
                  ),
                  SpecialtyIcon(
                    icon: FontAwesomeIcons.camera,
                    label: 'Photo Ops',
                  ),
                  SpecialtyIcon(
                    icon: FontAwesomeIcons.basketShopping,
                    label: 'Shopping',
                  ),
                  SpecialtyIcon(
                    icon: FontAwesomeIcons.route,
                    label: 'Navigation',
                  ),
                ]),
          ],
        ),
      ),
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
      height: 100,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: Colors.cyan,
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
          ),
        ],
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
        padding: const EdgeInsets.all(8.0),
        child: Row(children: const [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
                'https://bustickets.com/wp-content/uploads/2019/09/solo-travel-backpack-tips.jpg'),
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
            child: Text(
                '“Thorin is the BEST nativ around. He took us to incredible & authentic restaurants & guided an awesome hike.” \n -Jane Walenda, Traveler'),
          )
        ]),
      ),
    );
  }
}

class MainProfileInfo extends StatelessWidget {
  const MainProfileInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return ListTile(
      visualDensity: VisualDensity.comfortable,
      //leading: ProfileIcon(),
      title: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        children: const [
          Text(
            'Thorin Oakenshield',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Icon(
            FontAwesomeIcons.circleCheck,
            color: Colors.blueAccent,
            size: 20,
          )
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: const [
                Text('Auckland, NZ'),
                SizedBox(
                  height: 30,
                  child: Chip(
                    backgroundColor: Colors.orange,
                    label: Text(
                      'Top Rated',
                      style: TextStyle(color: Colors.white),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                )
              ]),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'I’m a born & raised New Zealander who loves hiking & finding the best food.',
            style: TextStyle(color: Colors.black87),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                  onPressed: () {
                    print('pressed');
                  },
                  style: Theme.of(context).elevatedButtonTheme.style,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: const [
                      Text(
                        'Connect ',
                      ),
                      Icon(FontAwesomeIcons.connectdevelop)
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActionChip(
                  label: const Text('Message Me'),
                  onPressed: () {},
                  avatar: const Icon(
                    FontAwesomeIcons.paperPlane,
                    size: 20,
                  ),
                ),
                SizedBox(
                  child: Wrap(spacing: 20, children: const [
                    Icon(FontAwesomeIcons.instagram),
                    Icon(FontAwesomeIcons.facebook),
                    Icon(FontAwesomeIcons.tiktok),
                    Icon(FontAwesomeIcons.twitter),
                  ]),
                ),
              ],
            ),
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
