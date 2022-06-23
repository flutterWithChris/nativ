import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'display_mode_state.dart';

class DisplayModeCubit extends Cubit<DisplayModeState> {
  DisplayModeCubit() : super(DisplayModeState.initial());

  void enableDarkMode() {
    // TODO: Implment Dark Mode Function & Store in Shared Prefs
    emit(state.copyWith(displayMode: DisplayMode.darkMode));
  }

  void enableLightMode() {
    // TODO: Implment Light Mode Function & Store in Shared Prefs
    emit(state.copyWith(displayMode: DisplayMode.lightMode));
  }
}
