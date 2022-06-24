import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nativ/bloc/login/login_cubit.dart';
import 'package:nativ/data/repositories/auth_repository.dart';
import 'package:nativ/view/screens/signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: LoginScreen());

  @override
  State<LoginScreen> createState() => _SignInState();
}

class _SignInState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginCubit(
          context.read<AuthRepository>(),
        ),
        child: LoginForm(
            emailController: emailController,
            passwordController: passwordController),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final String googleClientId = dotenv.get('GOOGLE_SERVICE_CLIENT_ID');

  LoginForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state.status == LoginStatus.error) {
          // TODO: Implement Error Handler
          _showSnackBar(context, 'test');
        }
      },
      child: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Image.asset(
              'lib/assets/mapbox-background.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.centerRight,
            ),
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white38,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 40.0,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SignupButton(),
                            _EmailInput(),
                            SizedBox(
                              height: 15,
                            ),
                            _PasswordInput(),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                        _loginButton(),
                        TextButton(
                            onPressed: () {},
                            child: const Text('Forgot Password?')),
                        const Text('OR'),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: ElevatedButton(
                              onPressed: () {
                                GoogleProviderConfiguration(
                                  clientId: googleClientId,
                                );
                                context
                                    .read<LoginCubit>()
                                    .logInWithGoogleCredentials();
                              },
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 15,
                                children: const [
                                  Icon(FontAwesomeIcons.google),
                                  Text('Sign In With Google')
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == LoginStatus.submitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<LoginCubit>().logInWithCredentials();
                  } else {
                    _showSnackBar(context, 'Login Error!');
                  }
                },
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 15,
                  children: const [
                    Icon(Icons.email),
                    Text('Sign Up With Email'),
                  ],
                ),
              );
      },
    );
  }
}

class SignupButton extends StatelessWidget {
  const SignupButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push<void>(SignupScreen.route());
      },
      child: const Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'New to Nativ? ',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        textAlign: TextAlign.left,
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
      child: BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return TextFormField(
            validator: (value) => state.isEmailValid ? null : 'Invalid Email!',
            onChanged: (value) =>
                context.read<LoginCubit>().emailChanged(value),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              label: const Text('Email Address'),
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

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 325,
      height: 50,
      child: BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          return TextFormField(
            validator: (value) =>
                state.isEmailValid ? null : 'Password is too short',
            obscureText: true,
            onChanged: (value) =>
                context.read<LoginCubit>().passwordChanged(value),
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              label: const Text('Password'),
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

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
