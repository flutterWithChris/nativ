import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nativ/bloc/location/location_bloc.dart';
import 'package:nativ/bloc/signup/signup_cubit.dart';
import 'package:nativ/data/repositories/auth_repository.dart';
import 'package:nativ/view/widgets/location_searchbar.dart';
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
    bool isPageComplete = false;
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
          emailController: emailController,
          emailConfirmController: emailConfirmController,
          passwordController: passwordController,
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        height: 60,
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
            isPageComplete == true
                ? TextButton(
                    onPressed: () {
                      controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut);
                    },
                    child: const Text('NEXT'),
                  )
                : Visibility(
                    visible: false,
                    child: TextButton(
                      onPressed: () {
                        controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut);
                      },
                      child: const Text('NEXT'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

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
  final _formKey = GlobalKey<FormState>();
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
        if (state.status == SignupStatus.error) {}

        // TODO: implement error handling
        _showSnackBar(context, 'Error Signing Up!');
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 70),
        child: PageView(
          controller: controller,
          children: [
            Form(
              key: _formKey,
              child: Center(
                child: SignupBasicInfoPage(formKey: _formKey),
              ),
            ),
            Stack(
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
                        const Text(
                          'Where Are You From?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
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
                                  child: const LocationSearchBar(),
                                );
                              } else {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 100),
                                  height: 78,
                                  child: const LocationSearchBar(),
                                );
                              }
                            }),
                          ),
                        ),
                        BlocBuilder<LocationBloc, LocationState>(
                          builder: (context, state) {
                            //   context.read<LocationBloc>().selectedLocation
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
                                        text: 'None!',
                                        style: TextStyle(fontSize: 18)),
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
            ),
            UserTypePage(controller: controller),
            BlocBuilder<SignupCubit, SignupState>(
              builder: (context, state) {
                if (state.isTraveler && state.isNativ) {
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
                        child: ListView(
                          shrinkWrap: true,
                          children: const [
                            Text(
                              'Traveler Profile Info',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            _NameInput()
                          ],
                        ),
                      ),
                    ],
                  );
                }
                if (state.isTraveler && state.isNativ == false) {
                  return Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Image.asset(
                        'lib/assets/mapbox-background.png',
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.centerRight,
                      ),
                      const Text('Traveler'),
                    ],
                  );
                }
                if (state.isNativ && state.isTraveler == false) {
                  return Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Image.asset(
                        'lib/assets/mapbox-background.png',
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.centerRight,
                      ),
                      const Text('Nativ'),
                    ],
                  );
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

class SignupBasicInfoPage extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  SignupBasicInfoPage({
    required this.formKey,
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
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Let\'s create your account.',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const _EmailInput(),
              const SizedBox(
                height: 15,
              ),
              const _ConfirmEmailInput(),
              const SizedBox(
                height: 15,
              ),
              const _PasswordInput(),
              const SizedBox(
                height: 15,
              ),
              SignupButton(formKey: formKey),
            ],
          ),
        ),
      ],
    );
  }
}

class UserTypePage extends StatelessWidget {
  PageController controller = PageController();
  UserTypePage({
    required this.controller,
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
                  children: [
                    ListTile(
                      enableFeedback: true,
                      onTap: () => {
                        context.read<SignupCubit>().isTraveler(true),
                        controller.nextPage(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOut)
                      },
                      leading: const Icon(
                        FontAwesomeIcons.plane,
                        color: Colors.black54,
                      ),
                      title: const Text('I\'m a Traveler'),
                      subtitle: const Text(
                          'I\'m interested in connecting with locals on my trips.'),
                      trailing: const Icon(
                        FontAwesomeIcons.circleArrowRight,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      enableFeedback: true,
                      onTap: () => {
                        context.read<SignupCubit>().isNativ(true),
                        controller.nextPage(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOut)
                      },
                      leading: const Icon(
                        FontAwesomeIcons.map,
                        color: Colors.black54,
                      ),
                      title: const Text('I\'m a Nativ'),
                      subtitle: const Text(
                          'I\'d love to help others explore & get to know my area!'),
                      trailing: const Icon(
                        FontAwesomeIcons.circleArrowRight,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      enableFeedback: true,
                      onTap: () {
                        context.read<SignupCubit>().isBoth(true);
                        controller.nextPage(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOut);
                      },
                      leading: const Icon(
                        FontAwesomeIcons.earthAmericas,
                        color: Colors.black54,
                      ),
                      title: const Text('I\'m interested in both!'),
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
        ),
      ],
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 325,
      height: 50,
      child: BlocBuilder<SignupCubit, SignupState>(
        //  buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return TextFormField(
            //  validator: (value) => state.isEmailValid ? null : 'Invalid Email',
            onChanged: (value) => print('Name Updated'),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: 'Your Name',
              label: const Text('Name'),
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
          return TextFormField(
            validator: (value) => state.isEmailValid ? null : 'Invalid Email',
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
            validator: (value) =>
                state.isConfirmEmailValid ? null : 'Email doesn\'t match!',
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
  var formKey = GlobalKey<FormState>();
  SignupButton({required this.formKey, Key? key}) : super(key: key);

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
                  if (formKey.currentState!.validate()) {
                    context.read<SignupCubit>().signupFormSubmitted();
                  } else {
                    _showSnackBar(context, 'Sign Up Error!');
                  }
                },
                child: const Text('Continue'));
      },
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
            validator: (value) =>
                state.isPasswordValid ? null : 'Password invalid!',
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
