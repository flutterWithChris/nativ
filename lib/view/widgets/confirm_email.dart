import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nativ/bloc/signup/signup_cubit.dart';

class ConfirmEmailInput extends StatelessWidget {
  const ConfirmEmailInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          validator: (value) =>
              value == state.email ? null : 'Email doesn\'t match!',
          //onChanged: (value) => context.read<SignupCubit>().emailChanged(value),
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
    );
  }
}
