import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nativ/bloc/login/login_cubit.dart';
import 'package:nativ/data/repositories/auth_repository.dart';
import 'package:nativ/view/screens/signup_screen.dart';

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
  const LoginForm({
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
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white38,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 40.0,
                    ),
                  ),
                  const _EmailInput(),
                  const SizedBox(
                    height: 15,
                  ),
                  const _PasswordInput(),
                  const SizedBox(
                    height: 15,
                  ),
                  const LoginButton(),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push<void>(SignupScreen.route());
                      },
                      child: const Text('Signup')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == LoginStatus.submitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(250, 40),
                ),
                onPressed: () {
                  context.read<LoginCubit>().logInWithCredentials();
                },
                child: const Text('Login ->'));
      },
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
          return TextField(
            onChanged: (value) =>
                context.read<LoginCubit>().emailChanged(value),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              label: const Text('Email'),
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
          return TextField(
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
