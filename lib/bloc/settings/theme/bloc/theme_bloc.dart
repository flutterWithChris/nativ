import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nativ/bloc/settings/preferences.dart';
import 'package:nativ/view/themes/app_themes.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(ThemeState(
            themeData: appThemeData[
                AppTheme.values[SharedPrefs().getThemeIndex ?? 0]]!)) {
    on<ThemeEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is ThemeChanged) {
        SharedPrefs().setThemeIndex = event.theme.index;
        emit.call(ThemeState(themeData: appThemeData[event.theme]!));
      }
    });
  }
}
