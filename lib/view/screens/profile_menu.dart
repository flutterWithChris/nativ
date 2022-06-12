import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            SizedBox(
              height: 200,
              child: Image.network(
                'https://static.euronews.com/articles/stories/06/25/84/50/1200x675_cmsv2_f71b6679-918e-5672-8b87-8f3e17af759e-6258450.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // * Main Content
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const MainProfileInfo(),
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.chevronLeft,
                          color: Colors.black38,
                        ),
                        FractionallySizedBox(
                            widthFactor: 0.80, child: ReviewCarousel()),
                        Icon(
                          FontAwesomeIcons.chevronRight,
                          color: Colors.black38,
                        ),
                      ]),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      //    transformAlignment: Alignment.center,
                      alignment: Alignment.center,
                      width: 400,
                      height: 225,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: Align(
                        alignment: Alignment.center,
                        child: Wrap(spacing: 15,
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
                      ),
                    ),
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
            color: Colors.black87,
          ),
          const SizedBox(
            height: 5,
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
    return Padding(
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
    );
  }
}

class MainProfileInfo extends StatelessWidget {
  const MainProfileInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.comfortable,
      leading: const CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage(
          'https://www.zbrushcentral.com/uploads/default/original/4X/7/9/6/7966865da1c1203fd5250ab05bb1fc00ba8133e9.jpeg',
        ),
      ),
      title: const Text(
        'Thorin Oakenshield',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                  height: 25,
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
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    fixedSize: const Size(400, 35),
                    primary: Colors.black54),
                child: const Text(
                  'Book Me',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              child: Wrap(spacing: 20, children: const [
                Icon(FontAwesomeIcons.instagram),
                Icon(FontAwesomeIcons.facebook),
                Icon(FontAwesomeIcons.tiktok),
                Icon(FontAwesomeIcons.twitter),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
