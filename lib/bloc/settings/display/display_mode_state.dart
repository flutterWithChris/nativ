part of 'display_mode_cubit.dart';

enum DisplayMode { lightMode, darkMode }

class DisplayModeState extends Equatable {
  final DisplayMode displayMode;

  const DisplayModeState({required this.displayMode});

  factory DisplayModeState.initial() {
    return const DisplayModeState(displayMode: DisplayMode.lightMode);
  }

  @override
  List<Object> get props => [displayMode];

  DisplayModeState copyWith({DisplayMode? displayMode}) {
    return DisplayModeState(displayMode: displayMode ?? this.displayMode);
  }
}
