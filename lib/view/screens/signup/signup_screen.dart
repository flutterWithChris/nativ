import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nativ/bloc/onboarding/onboarding_bloc.dart';
import 'package:nativ/view/screens/signup/signup_form.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);
  final PageController controller = PageController();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SignupScreen());
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController emailConfirmController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    bool isNextButtonEnabled = false;
    int currentPageIndex = 1;

    void setCurrentPage(int pageNumber) {
      currentPageIndex = pageNumber;
    }

    return Scaffold(
      // appBar: AppBar(),
      body: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white38,
            child: SignupForm(
              currentPageIndex: currentPageIndex,
              controller: controller,
              emailController: emailController,
              emailConfirmController: emailConfirmController,
              passwordController: passwordController,
            ),
          );
        },
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => controller.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut),
                child: const Text('BACK'),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: SmoothPageIndicator(
                  onDotClicked: (index) => controller.animateToPage(index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut),
                  controller: controller,
                  count: 4,
                  effect: WormEffect(
                    spacing: 16,
                    dotColor: Colors.black26,
                    activeDotColor: Colors.teal.shade700,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                  onPressed: isNextButtonEnabled
                      ? () {
                          _goToNextPage();
                        }
                      : null,
                  child: const Text('NEXT')),
            ),
          ],
        ),
      ),
    );
  }

  _goToNextPage() async {
    await controller.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }
}

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
