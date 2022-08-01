import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nativ/bloc/onboarding/onboarding_bloc.dart';
import 'package:nativ/bloc/signup/signup_cubit.dart';
import 'package:nativ/data/model/user.dart';
import 'package:nativ/main.dart';

class SignupBasicInfoPage extends StatelessWidget {
  static GlobalKey<FormState> signupformKey = GlobalKey<FormState>();
  PageController pageController;
  SignupBasicInfoPage({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: MainAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 120),
                  child: Form(
                    key: signupformKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 25.0, horizontal: 15.0),
                          child: Text('Hey! Let\'s get you signed up.',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .appBarTheme
                                        .backgroundColor,
                                    fontWeight: FontWeight.bold,
                                  )),
                        ),
                        EmailInput(),
                        const SizedBox(
                          height: 5,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            const PasswordInput(),
                            const SizedBox(
                              height: 20,
                            ),
                            SignupButton(
                                formKey: signupformKey,
                                pageController: pageController),
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'OR',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            GoogleSignupButton(
                                formKey: signupformKey,
                                pageController: pageController),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                LinearProgressIndicator(
                  backgroundColor: Colors.grey,
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  value: 1,
                ),
              ],
            ),
          ),
        ),
      ),
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

class SignupButton extends StatefulWidget {
  final PageController pageController;
  var formKey = GlobalKey<FormState>();
  SignupButton({
    Key? key,
    required this.formKey,
    required this.pageController,
  }) : super(key: key);

  @override
  State<SignupButton> createState() => _SignupButtonState();
}

class _SignupButtonState extends State<SignupButton> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.success) {
          widget.pageController.animateToPage(
              widget.pageController.page!.toInt() + 1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
          /*  pageController.nextPage(
              duration: const Duration(seconds: 1), curve: Curves.easeInOut); */
        }
      },
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == SignupStatus.submitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async {
                  if (widget.formKey.currentState!.validate()) {
                    print('Sign in Clicked');
                    await context.read<SignupCubit>().signupFormSubmitted();
                    // * Create User Object
                    if (!mounted) return;
                    User user = User(
                      id: context.read<SignupCubit>().state.user!.uid,
                      name: '',
                      location: '',
                      email: context.read<SignupCubit>().state.user!.email,
                      username: '',
                      reviews: const {},
                      specialties: const [],
                      types: const [],
                      bio: '',
                      photo: '',
                      visitedPlaces: const [],
                    );
                    // * Start Onboarding Event
                    context
                        .read<OnboardingBloc>()
                        .add(StartOnboarding(user: user));
                  } else {
                    _showSnackBar(context, 'Sign Up Error!');
                  }
                },
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 15,
                  children: const [
                    Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    Text(
                      'Sign Up With Email',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
      },
    );
  }
}

class GoogleSignupButton extends StatefulWidget {
  final PageController pageController;
  var formKey = GlobalKey<FormState>();

  GoogleSignupButton({
    Key? key,
    required this.formKey,
    required this.pageController,
  }) : super(key: key);

  @override
  State<GoogleSignupButton> createState() => _GoogleSignupButtonState();
}

class _GoogleSignupButtonState extends State<GoogleSignupButton> {
  final String googleClientId = dotenv.get('GOOGLE_SERVICE_CLIENT_ID');

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.success) {
          widget.pageController.animateToPage(
              widget.pageController.page!.toInt() + 1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        }
      },
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == SignupStatus.submitting
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: InkWell(
                  child: CircleAvatar(
                    radius: 21,
                    backgroundColor: Colors.grey.shade400,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      child: IconButton(
                        iconSize: 32,
                        icon: Image.network(
                          'http://pngimg.com/uploads/google/google_PNG19635.png',
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            FontAwesomeIcons.google,
                            color: Colors.black54,
                          ),
                        ),
                        splashColor: Colors.white,
                        onPressed: () async {
                          GoogleProviderConfiguration(
                            clientId: googleClientId,
                          );
                          await context
                              .read<SignupCubit>()
                              .signUpWithGoogleCredentials();

                          if (!mounted) return;
                          User user = User(
                              id: context.read<SignupCubit>().state.user!.uid,
                              name: '',
                              location: '',
                              email:
                                  context.read<SignupCubit>().state.user!.email,
                              username: '',
                              reviews: const {},
                              specialties: const [],
                              types: const [],
                              bio: '',
                              photo: '',
                              visitedPlaces: const []);

                          context
                              .read<OnboardingBloc>()
                              .add(StartOnboarding(user: user));
                        },
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class NameInput extends StatelessWidget {
  const NameInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
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
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          validator: (value) =>
              state.isPasswordValid ? null : 'Password invalid!',
          onChanged: (value) =>
              context.read<SignupCubit>().passwordChanged(value),
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            label: Text('Create a password'),
          ),
        );
      },
    );
  }
}

class EmailInput extends StatefulWidget {
  TextEditingController emailController = TextEditingController();

  EmailInput({
    Key? key,
  }) : super(key: key);

  @override
  State<EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          controller: widget.emailController,
          validator: (value) => state.isEmailValid ? null : 'Invalid Email',
          onChanged: (value) {
            context.read<SignupCubit>().emailChanged(value);
          },
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'you@example.com',
            label: Text('Enter your email'),
          ),
        );
      },
    );
  }
}
