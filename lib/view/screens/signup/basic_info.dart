import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nativ/bloc/onboarding/onboarding_bloc.dart';
import 'package:nativ/bloc/signup/signup_cubit.dart';
import 'package:nativ/data/model/user.dart';

class SignupBasicInfoPage extends StatelessWidget {
  static GlobalKey<FormState> signupformKey = GlobalKey<FormState>();
  PageController pageController;
  SignupBasicInfoPage({
    Key? key,
    required this.pageController,
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
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Form(
                    key: signupformKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email Signup',
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(
                          height: 15,
                        ),
                        EmailInput(),
                        const SizedBox(
                          height: 5,
                        ),
                        // const ConfirmEmailInput(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
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
                                pageController: pageController)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                        photo: '');
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
          /*  pageController.nextPage(
              duration: const Duration(seconds: 1), curve: Curves.easeInOut); */
        }
      },
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == SignupStatus.submitting
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xffF5FCFF)),
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
                        email: context.read<SignupCubit>().state.user!.email,
                        username: '',
                        reviews: const {},
                        specialties: const [],
                        types: const [],
                        bio: '',
                        photo: '');

                    context
                        .read<OnboardingBloc>()
                        .add(StartOnboarding(user: user));
                  },
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 15,
                    children: [
                      Image.network(
                        'http://pngimg.com/uploads/google/google_PNG19635.png',
                        height: 30,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          FontAwesomeIcons.google,
                          color: Colors.black54,
                        ),
                      ),
                      const Text(
                        'Sign Up With Google',
                      )
                    ],
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
    );
  }
}
