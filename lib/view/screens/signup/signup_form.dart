import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nativ/bloc/location/location_bloc.dart';
import 'package:nativ/bloc/signup/signup_cubit.dart';
import 'package:nativ/data/model/place.dart';
import 'package:nativ/view/screens/signup/basic_info.dart';
import 'package:nativ/view/screens/signup/user_type.dart';
import 'package:nativ/view/widgets/location_searchbar.dart';

class SignupForm extends StatefulWidget {
  final PageController controller;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController emailConfirmController;
  int currentPageIndex;
  SignupForm(
      {required this.controller,
      required this.emailController,
      required this.emailConfirmController,
      required this.passwordController,
      required this.currentPageIndex,
      Key? key})
      : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  double searchbarHeight = 80;
  @override
  Widget build(BuildContext context) {
    var controller = widget.controller;
    int currentPageIndex = widget.currentPageIndex;

    @override
    void dispose() {
      controller.dispose();
      super.dispose();
    }

    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.error) {
          _showSnackBar(context, 'Error Signing Up!');
        }

        // TODO: implement error handling
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 50),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: [
            SignupBasicInfoPage(pageController: widget.controller),
            SetLocationScreen(pageController: widget.controller),
            UserTypePage(controller: controller),
            BlocBuilder<SignupCubit, SignupState>(
              builder: (context, state) {
                if (state.isTraveler && state.isNativ) {
                  return const NativAndTravelerProfileSetup();
                }
                if (state.isTraveler && state.isNativ == false) {
                  return const TravelerProfileSetup();
                }
                if (state.isNativ && state.isTraveler == false) {
                  return const NativProfileSetup();
                }
                return Container();
              },
            ),
            Container(
              color: Colors.blue,
            ),
            Container(
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

class NativAndTravelerProfileSetup extends StatelessWidget {
  const NativAndTravelerProfileSetup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Image.asset(
          'lib/assets/mapbox-background.png',
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.centerRight,
        ),
        Center(
            child: PageView(
          children: const [
            TravelerProfileSetup(),
            NativProfileSetup(),
          ],
        )),
      ],
    );
  }
}

class NativProfileSetup extends StatelessWidget {
  const NativProfileSetup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Image.asset(
          'lib/assets/mapbox-background.png',
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.centerRight,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'As a Nativ::',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const SizedBox(
                    height: 125,
                    child: TextField(
                      maxLength: 125,
                      decoration: InputDecoration(
                        label: Text('Describe Yourself'),
                        hintText:
                            '"Born & raised in New Zealand. I enjoy exploring the world."',
                        hintStyle: TextStyle(overflow: TextOverflow.fade),
                      ),
                      expands: true,
                      maxLines: null,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'I know a lot about:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Wrap(
                      spacing: 10,
                      children: [
                        _buildInputChip(const Text('Hiking'),
                            const Icon(Icons.hiking), Colors.white),
                        _buildInputChip(
                            const Text('Food'),
                            const Icon(
                              FontAwesomeIcons.utensils,
                              size: 18,
                            ),
                            Colors.white),
                        _buildInputChip(
                            const Text('Shopping'),
                            const Icon(
                              FontAwesomeIcons.bagShopping,
                              size: 18,
                            ),
                            Colors.white),
                        _buildInputChip(
                            const Text('Entertainment'),
                            const Icon(
                              FontAwesomeIcons.music,
                              size: 18,
                            ),
                            Colors.white),
                        _buildInputChip(
                            const Text('Bars / Nightlife'),
                            const Icon(
                              FontAwesomeIcons.martiniGlass,
                              size: 18,
                            ),
                            Colors.white),
                        _buildInputChip(
                            const Text('Exploring'),
                            const Icon(
                              FontAwesomeIcons.mountainSun,
                              size: 18,
                            ),
                            Colors.white),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class TravelerProfileSetup extends StatelessWidget {
  const TravelerProfileSetup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Image.asset(
          'lib/assets/mapbox-background.png',
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.centerRight,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'Traveler Profile:',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const SizedBox(
                    height: 125,
                    child: TextField(
                      maxLength: 125,
                      decoration: InputDecoration(
                        label: Text('Describe Yourself'),
                        hintText:
                            '"I like to explore remote locations with awesome views."',
                        hintStyle: TextStyle(overflow: TextOverflow.fade),
                      ),
                      expands: true,
                      maxLines: null,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'While Traveling I Enjoy:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Wrap(
                      spacing: 10,
                      children: [
                        _buildInputChip(const Text('Hiking'),
                            const Icon(Icons.hiking), Colors.white),
                        _buildInputChip(
                            const Text('Food'),
                            const Icon(
                              FontAwesomeIcons.utensils,
                              size: 18,
                            ),
                            Colors.white),
                        _buildInputChip(
                            const Text('Shopping'),
                            const Icon(
                              FontAwesomeIcons.bagShopping,
                              size: 18,
                            ),
                            Colors.white),
                        _buildInputChip(
                            const Text('Entertainment'),
                            const Icon(
                              FontAwesomeIcons.music,
                              size: 18,
                            ),
                            Colors.white),
                        _buildInputChip(
                            const Text('Bars / Nightlife'),
                            const Icon(
                              FontAwesomeIcons.martiniGlass,
                              size: 18,
                            ),
                            Colors.white),
                        _buildInputChip(
                            const Text('Exploring'),
                            const Icon(
                              FontAwesomeIcons.mountainSun,
                              size: 18,
                            ),
                            Colors.white),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

_buildInputChip(Widget label, Widget avatar, Color backgroundColor) {
  bool isSelected = false;
  return InputChip(
    label: label,
    avatar: avatar,
    backgroundColor: backgroundColor,
    selected: isSelected,
    onSelected: (bool selected) {
      isSelected = selected;
    },
  );
}

class SetLocationScreen extends StatelessWidget {
  final PageController pageController;
  const SetLocationScreen({
    required this.pageController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Image.asset(
          'lib/assets/mapbox-background.png',
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.centerRight,
        ),
        ListView(
          shrinkWrap: true,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  'Where Are You From?',
                  style: Theme.of(context).textTheme.headlineSmall,
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
                StreamBuilder<Place>(
                  stream: context.read<LocationBloc>().selectedLocation.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var setLocation = snapshot.data as Place;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.9,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Set Location: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.black87),
                                          ),
                                          TextSpan(
                                              text: setLocation.name,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black87)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    pageController.animateToPage(
                                        pageController.page!.toInt() + 1,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut);
                                  },
                                  child: const Text('Continue')),
                            ],
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Set Location: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87),
                            ),
                            TextSpan(
                                text: 'None',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black87)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
