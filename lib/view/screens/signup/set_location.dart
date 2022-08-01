import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nativ/bloc/location/location_bloc.dart';
import 'package:nativ/bloc/onboarding/onboarding_bloc.dart';
import 'package:nativ/bloc/signup/signup_cubit.dart';
import 'package:nativ/data/model/place.dart';
import 'package:nativ/view/widgets/location_searchbar.dart';

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
        ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Where Are You From?',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).appBarTheme.backgroundColor,
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
                BlocProvider.value(
                  value: context.read<OnboardingBloc>(),
                  child: BlocBuilder<OnboardingBloc, OnboardingState>(
                    builder: (context, state) {
                      if (state is OnboardingLoading) {
                        return const CircularProgressIndicator();
                      }
                      if (state is OnboardingLoaded) {
                        return StreamBuilder<Place>(
                          stream: context
                              .read<LocationBloc>()
                              .selectedLocation
                              .stream,
                          builder: (context, snapshot) {
                            var user = context.read<SignupCubit>().state.user!;
                            if (snapshot.hasData) {
                              var setLocation = snapshot.data as Place;
                              context.read<OnboardingBloc>().add(UpdateUser(
                                  user: state.user
                                      .copyWith(location: setLocation.name)));
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 25.0),
                                child: FractionallySizedBox(
                                  widthFactor: 0.9,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors.black87),
                                                  ),
                                                  TextSpan(
                                                      text: setLocation.name,
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Colors.black87)),
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
                                                pageController.page!.toInt() +
                                                    1,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.easeInOut);
                                          },
                                          child: const Text(
                                            'Continue',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 25.0),
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
                                            fontSize: 18,
                                            color: Colors.black87)),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const Center(
                        child: Text('Something Went Wrong!'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
