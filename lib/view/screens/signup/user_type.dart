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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Which describes you?',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      fontWeight: FontWeight.bold),
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
                            user: state.user.copyWith(types: ['traveler']))),
                        context.read<SignupCubit>().isTraveler(true),
                        controller.nextPage(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOut)
                      },
                      leading: const SizedBox(
                        height: 50,
                        child: Icon(
                          FontAwesomeIcons.plane,
                        ),
                      ),
                      title: const Text(
                        'I\'m a Traveler',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                          'I\'m interested in connecting with locals on my trips.'),
                      trailing: const SizedBox(
                        height: 60,
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFFBB92CB),
                        ),
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
                      leading: const SizedBox(
                        height: 50,
                        child: Icon(
                          FontAwesomeIcons.map,
                        ),
                      ),
                      title: const Text(
                        'I\'m a Nativ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                          'I\'d love to help others explore & get to know my area!'),
                      trailing: const SizedBox(
                        height: 60,
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFFBB92CB),
                        ),
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
                      leading: const SizedBox(
                        height: 50,
                        child: Icon(
                          FontAwesomeIcons.earthAmericas,
                        ),
                      ),
                      title: const Text(
                        'I\'m interested in both!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                          'I love traveling the world & also helping others explore it!'),
                      trailing: const SizedBox(
                        height: 60,
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFFBB92CB),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //SignupButton(),
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
