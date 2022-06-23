import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:nativ/bloc/signup/signup_cubit.dart';
import 'package:nativ/data/repositories/storage/storage_repository.dart';
import 'package:nativ/view/widgets/confirm_email.dart';

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
                        Text('What\'s Your Email Address?',
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(
                          height: 15,
                        ),
                        EmailInput(),
                        const SizedBox(
                          height: 15,
                        ),
                        const ConfirmEmailInput(),
                        const SizedBox(
                          height: 25,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Choose a Password',
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
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

class SignupButton extends StatelessWidget {
  final PageController pageController;
  var formKey = GlobalKey<FormState>();
  SignupButton({
    Key? key,
    required this.formKey,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.success) {
          pageController.animateToPage(pageController.page!.toInt() + 1,
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
                style: ElevatedButton.styleFrom(fixedSize: const Size(200, 40)),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    print('Sign in Clicked');
                    await context.read<SignupCubit>().signupFormSubmitted();
                  } else {
                    _showSnackBar(context, 'Sign Up Error!');
                  }
                },
                child: const Text('Continue'));
      },
    );
  }
}

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        ImagePicker picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);

        if (image == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No Image(s) Added!'),
            backgroundColor: Colors.redAccent,
          ));
        }

        if (image != null) {
          StorageRepository().uploadImage(image);
          print('Uploading.......');
        }
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: const [
          CircleAvatar(
            radius: 40,
          ),
          Icon(
            Icons.add_circle,
            color: Colors.redAccent,
          )
        ],
      ),
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
          onChanged: (value) => context.read<SignupCubit>().emailChanged(value),
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
