import 'package:flutter/material.dart';
import 'package:nativ/bloc/app/app_bloc.dart';
import 'package:nativ/view/pages/main.dart';
import 'package:nativ/view/screens/login_screen.dart';

List<Page> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomeScreen.page()];
    case AppStatus.unauthenticated:
      return [LoginScreen.page()];
  }
}
