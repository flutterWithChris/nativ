import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nativ/bloc/signup/signup_cubit.dart';
import 'package:nativ/data/repositories/auth_repository.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);
  final PageController controller = PageController();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SignupScreen());
  }

  @override
  Widget build(BuildContext context) {
    int currentPageIndex = 1;

    void setCurrentPage(int pageNumber) {
      currentPageIndex = pageNumber;
    }

    return Scaffold(
      body: BlocProvider<SignupCubit>(
        create: (context) => SignupCubit(context.read<AuthRepository>()),
        child: SignupForm(
          currentPageIndex: currentPageIndex,
          controller: controller,
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            controller.hasClients && controller.page! > 1
                ? Visibility(
                    visible: false,
                    child: TextButton(
                      onPressed: () => controller.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                      child: const Text('BACK'),
                    ),
                  )
                : Visibility(
                    visible: true,
                    child: TextButton(
                      onPressed: () => controller.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                      child: const Text('BACK'),
                    ),
                  ),
            Center(
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
            TextButton(
              onPressed: () {
                controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut);
              },
              child: const Text('NEXT'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  final PageController controller;
  int currentPageIndex;
  SignupForm(
      {required this.controller, required this.currentPageIndex, Key? key})
      : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
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
        // TODO: implement error handling
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          children: [
            Container(
              child: const Center(
                child: SignupBasicInfoPage(),
              ),
            ),
            Container(
              child: const UserTypePage(),
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

class SignupBasicInfoPage extends StatelessWidget {
  const SignupBasicInfoPage({
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
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white38,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Let\'s create your account.',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _EmailInput(),
              SizedBox(
                height: 15,
              ),
              _ConfirmEmailInput(),
              SizedBox(
                height: 15,
              ),
              _PasswordInput(),
              SizedBox(
                height: 15,
              ),
              //SignupButton(),
            ],
          ),
        ),
      ],
    );
  }
}

class UserTypePage extends StatelessWidget {
  const UserTypePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      // alignment: AlignmentDirectional.centerStart,
      children: [
        Image.asset(
          'lib/assets/mapbox-background.png',
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.centerLeft,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white38,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Which describes you?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.plane,
                        color: Colors.black54,
                      ),
                      title: Text('I\'m a Traveler'),
                      subtitle: Text(
                          'I\'m interested in connecting with locals on my trips.'),
                      trailing: Icon(
                        FontAwesomeIcons.circleArrowRight,
                        color: Colors.blueAccent,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.map,
                        color: Colors.black54,
                      ),
                      title: Text('I\'m a Nativ'),
                      subtitle: Text(
                          'I\'d love to help others explore & get to know my area!'),
                      trailing: Icon(
                        FontAwesomeIcons.circleArrowRight,
                        color: Colors.blueAccent,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.earthAmericas,
                        color: Colors.black54,
                      ),
                      title: Text('I\'m interested in both!'),
                      subtitle: Text(
                          'I love traveling the world & also helping others explore it!'),
                      trailing: Icon(
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
        ),
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 325,
      height: 50,
      child: BlocBuilder<SignupCubit, SignupState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return TextField(
            onChanged: (value) =>
                context.read<SignupCubit>().emailChanged(value),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'you@example.com',
              label: const Text('Enter your email'),
              filled: true,
              fillColor: Colors.white70,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45.0),
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none)),
            ),
          );
        },
      ),
    );
  }
}

class _ConfirmEmailInput extends StatelessWidget {
  const _ConfirmEmailInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 325,
      height: 50,
      child: BlocBuilder<SignupCubit, SignupState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return TextFormField(
            onChanged: (value) =>
                context.read<SignupCubit>().emailChanged(value),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'you@example.com',
              label: const Text('Confirm your email'),
              filled: true,
              fillColor: Colors.white70,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45.0),
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none)),
            ),
          );
        },
      ),
    );
  }
}

class SignupButton extends StatelessWidget {
  const SignupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == SignupStatus.submitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: const Size(200, 40)),
                onPressed: () {
                  context.read<SignupCubit>().signupFormSubmitted();
                },
                child: const Text('Continue'));
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 325,
      height: 50,
      child: BlocBuilder<SignupCubit, SignupState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          return TextFormField(
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            onChanged: (value) =>
                context.read<SignupCubit>().passwordChanged(value),
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              label: const Text('Create a password'),
              filled: true,
              fillColor: Colors.white70,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45.0),
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none)),
            ),
          );
        },
      ),
    );
  }
}
