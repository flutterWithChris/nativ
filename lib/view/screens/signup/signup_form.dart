import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nativ/bloc/onboarding/onboarding_bloc.dart';
import 'package:nativ/bloc/signup/signup_cubit.dart';
import 'package:nativ/view/pages/profile_setup.dart';
import 'package:nativ/view/screens/signup/basic_info.dart';
import 'package:nativ/view/screens/signup/set_location.dart';
import 'package:nativ/view/screens/signup/user_type.dart';

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
            BlocBuilder<OnboardingBloc, OnboardingState>(
              builder: (context, state) {
                if (state is OnboardingLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is OnboardingLoaded) {
                  return const ProfileSetup();
                }
                return const Center(
                  child: Text('Something Went Wrong'),
                );
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

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
