import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:nativ/bloc/app/app_bloc.dart';
import 'package:nativ/bloc/location/location_bloc.dart';
import 'package:nativ/bloc/onboarding/onboarding_bloc.dart';
import 'package:nativ/data/model/specialty.dart';
import 'package:nativ/view/widgets/location_searchbar.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: ProfileSetup());

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Colors.white,
        child: ListView(
          children: [
            // * Header Image
            AspectRatio(
                aspectRatio: 1.91 / 1,
                child: Container(
                  color: const Color(0xffBFD5DF),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_a_photo_rounded),
                      SizedBox(height: 7),
                      Text('Add Image')
                    ],
                  )),
                )),
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
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: FractionallySizedBox(
                        widthFactor: 0.9, child: Divider()),
                  ),
                  // * Specialties
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: MySpecialties(),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: FractionallySizedBox(
                        widthFactor: 0.9, child: Divider()),
                  ),
                  // * Add Trips
                  const AddTripsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTripsWidget extends StatefulWidget {
  const AddTripsWidget({Key? key}) : super(key: key);

  @override
  State<AddTripsWidget> createState() => _AddTripsWidgetState();
}

class _AddTripsWidgetState extends State<AddTripsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Where have you visited?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: BlocBuilder<LocationBloc, LocationState>(
            builder: ((context, state) {
              if (state is LocationSearchbarFocused ||
                  state is LocationSearchStarted) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: 400,
                  child: LocationSearchBar(
                    hintText: 'Search Cities...',
                  ),
                );
              } else {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: 78,
                  child: LocationSearchBar(
                    hintText: 'Search Cities...',
                  ),
                );
              }
            }),
          ),
        ),
      ]),
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

class MySpecialties extends StatefulWidget {
  const MySpecialties({
    Key? key,
  }) : super(key: key);

  @override
  State<MySpecialties> createState() => _MySpecialtiesState();
}

class _MySpecialtiesState extends State<MySpecialties> {
  static List<String> selectedSpecialties = [];

  @override
  Widget build(BuildContext context) {
    List<Specialty> specialtySample = [
      Specialty(
        name: const Text('Entertainment'),
        color: Colors.orangeAccent,
        icon: const Icon(
          FontAwesomeIcons.music,
          size: 21,
        ),
      ),
      Specialty(
        name: const Text(
          'Local Bars',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.black54,
        icon: const Icon(
          FontAwesomeIcons.beerMugEmpty,
          size: 21,
          color: Colors.white,
        ),
      ),
      Specialty(
        name: const Text('Local Food'),
        color: Colors.white,
        icon: const Icon(
          FontAwesomeIcons.utensils,
          size: 20,
        ),
      ),
      Specialty(
        name: const Text('Navigation'),
        color: Colors.greenAccent,
        icon: const Icon(
          FontAwesomeIcons.route,
          size: 22,
          color: Colors.lightBlue,
        ),
      ),
      Specialty(
        name: const Text('Nature'),
        color: Colors.lightBlueAccent,
        icon: const Icon(
          FontAwesomeIcons.tree,
          color: Colors.green,
          size: 22,
        ),
      ),
      Specialty(
        name: const Text('Wildlife'),
        color: Colors.lightGreenAccent,
        icon: const Icon(
          FontAwesomeIcons.kiwiBird,
          size: 21,
          color: Colors.brown,
        ),
      ),
    ];
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        // color: const Color(0xffBFD5DF),
        child: Container(
          //color: Colors.black,
          //    transformAlignment: Alignment.center,
          alignment: Alignment.center,
          width: 400,
          height: 250,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'What are your specialties?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 15,
                    direction: Axis.horizontal,
                    children: specialtySample
                        .map((i) => SpecialtyChip(
                            specialtiesList: selectedSpecialties,
                            label: i.name,
                            color: i.color,
                            avatar: i.icon,
                            selected: i.selected,
                            onSelected: i.onSelected))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SpecialtyChip extends StatefulWidget {
  List<String> specialtiesList;
  Text label;
  Icon? avatar;
  Color? color;
  bool? selected;
  bool? showCheckmark;
  Function(bool)? onSelected;
  SpecialtyChip({
    Key? key,
    required this.specialtiesList,
    required this.label,
    required this.avatar,
    required this.selected,
    this.showCheckmark,
    this.color,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<SpecialtyChip> createState() => _SpecialtyChipState();
}

class _SpecialtyChipState extends State<SpecialtyChip> {
  @override
  Widget build(BuildContext context) {
    List<String> selectedList = widget.specialtiesList;

    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is OnboardingLoaded) {
          return InputChip(
            label: widget.label,
            selected: widget.selected ?? false,
            selectedColor: widget.color ?? widget.color,
            avatar: widget.avatar ?? widget.avatar,
            showCheckmark: widget.showCheckmark ?? true,
            onSelected: widget.onSelected ??
                (selected) {
                  // * Add/Remove Specialty to/from User Object
                  if (selected == true) {
                    selectedList.add(widget.label.data!);
                    context.read<OnboardingBloc>().add(UpdateUser(
                        user: state.user.copyWith(specialties: selectedList)));
                  }
                  if (selected != true) {
                    selectedList.remove(widget.label.data!);
                    context.read<OnboardingBloc>().add(UpdateUser(
                        user: state.user.copyWith(specialties: selectedList)));
                  }
                  // * Selected State Changes
                  setState(() {
                    widget.selected = selected;
                  });
                },
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
      height: 100,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: Colors.white,
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
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
      title: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: 0.75,
          child: BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (context, state) {
              if (state is OnboardingLoading) {
                return const CircularProgressIndicator();
              }
              if (state is OnboardingLoaded) {
                return TextFormField(
                  keyboardType: TextInputType.name,
                  onChanged: (value) => context
                      .read<OnboardingBloc>()
                      .add(UpdateUser(user: state.user.copyWith(name: value))),
                  style: const TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    label: const Text('Your Name'),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  showCursor: true,
                );
              } else {
                return const Text('Something Went Wrong..');
              }
            },
          ),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.95,
              child: BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, state) {
                  if (state is OnboardingLoading) {
                    return const CircularProgressIndicator();
                  }
                  if (state is OnboardingLoaded) {
                    return TextFormField(
                      onChanged: (value) => context.read<OnboardingBloc>().add(
                          UpdateUser(user: state.user.copyWith(bio: value))),
                      maxLines: 3,
                      minLines: 2,
                      maxLength: 90,
                      decoration: InputDecoration(
                        label: const Text('Your Bio'),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      showCursor: true,
                    );
                  } else {
                    return const Center(
                      child: Text('Something Went Wrong...'),
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Connect Accounts:'),
                SizedBox(
                  child: Wrap(spacing: 16, children: const [
                    FacebookSignInIconButton(clientId: ''),
                    TwitterSignInIconButton(
                      apiKey: '',
                      apiSecretKey: '',
                      redirectUri: '',
                    ),
                    AppleSignInIconButton(),
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

class ProfileIcon extends StatefulWidget {
  const ProfileIcon({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileIcon> createState() => _ProfileIconState();
}

class _ProfileIconState extends State<ProfileIcon> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingLoading) {
          return const CircularProgressIndicator();
        }
        if (state is OnboardingLoaded) {
          return InkWell(
            onTap: () async {
              ImagePicker picker = ImagePicker();
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              if (!mounted) return;
              if (image == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('No Image(s) Added!'),
                  backgroundColor: Colors.redAccent,
                ));
              }

              if (image != null) {
                context
                    .read<OnboardingBloc>()
                    .add(UpdateUserImages(image: image));
                print('Uploading.......');
              }
            },
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: const [
                CircleAvatar(
                  backgroundColor: Color(0xffBFD5DF),
                  foregroundColor: Colors.black87,
                  radius: 36,
                  child: Center(
                    child: Icon(Icons.add_a_photo_rounded),
                  ),
                ),
                Icon(
                  Icons.add_circle,
                  color: Colors.redAccent,
                )
              ],
            ),
          );
        } else {
          return const Text('Something went wrong.');
        }
      },
    );
  }
}
