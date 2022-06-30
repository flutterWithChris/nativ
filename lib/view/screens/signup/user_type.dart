import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nativ/bloc/onboarding/onboarding_bloc.dart';
import 'package:nativ/bloc/signup/signup_cubit.dart';

class UserTypePage extends StatelessWidget {
  PageController controller = PageController();
  UserTypePage({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is OnboardingLoaded) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Image.asset(
                'lib/assets/mapbox-background.png',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.centerLeft,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Which describes you?',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Column(
                      children: [
                        ListTile(
                          minVerticalPadding: 15,
                          enableFeedback: true,
                          onTap: () => {
                            context.read<OnboardingBloc>().add(UpdateUser(
                                user:
                                    state.user.copyWith(types: ['traveler']))),
                            context.read<SignupCubit>().isTraveler(true),
                            controller.nextPage(
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeInOut)
                          },
                          leading: const Icon(
                            FontAwesomeIcons.plane,
                            color: Colors.black54,
                          ),
                          title: const Text(
                            'I\'m a Traveler',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text(
                              'I\'m interested in connecting with locals on my trips.'),
                          trailing: const Icon(
                            FontAwesomeIcons.circleArrowRight,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          minVerticalPadding: 15,
                          enableFeedback: true,
                          onTap: () => {
                            context.read<OnboardingBloc>().add(UpdateUser(
                                user: state.user.copyWith(types: ['nativ']))),
                            context.read<SignupCubit>().isNativ(true),
                            controller.nextPage(
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeInOut)
                          },
                          leading: const Icon(
                            FontAwesomeIcons.map,
                            color: Colors.black54,
                          ),
                          title: const Text(
                            'I\'m a Nativ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text(
                              'I\'d love to help others explore & get to know my area!'),
                          trailing: const Icon(
                            FontAwesomeIcons.circleArrowRight,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          minVerticalPadding: 15,
                          enableFeedback: true,
                          onTap: () {
                            context.read<OnboardingBloc>().add(UpdateUser(
                                user: state.user
                                    .copyWith(types: ['traveler', 'nativ'])));
                            context.read<SignupCubit>().isBoth(true);
                            controller.nextPage(
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeInOut);
                          },
                          leading: const Icon(
                            FontAwesomeIcons.earthAmericas,
                            color: Colors.black54,
                          ),
                          title: const Text(
                            'I\'m interested in both!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text(
                              'I love traveling the world & also helping others explore it!'),
                          trailing: const Icon(
                            FontAwesomeIcons.circleArrowRight,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //SignupButton(),
                ],
              ),
            ],
          );
        } else {
          return const Center(
            child: Text('Something went wrong!'),
          );
        }
      },
    );
  }
}
