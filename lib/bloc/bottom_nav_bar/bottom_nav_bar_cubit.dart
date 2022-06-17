import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  int tabIndex = 1;

  void changeTabIndex(int index) {
    tabIndex = index;
  }

  BottomNavBarCubit()
      : super(const BottomNavBarState(BottomNavBarItem.home, 1));

  void getNavBarItem(BottomNavBarItem bottomNavBarItem) {
    switch (bottomNavBarItem) {
      case BottomNavBarItem.home:
        emit(const BottomNavBarState(BottomNavBarItem.home, 1));
        break;
      case BottomNavBarItem.profile:
        emit(const BottomNavBarState(BottomNavBarItem.profile, 0));
        break;
      case BottomNavBarItem.settings:
        emit(const BottomNavBarState(BottomNavBarItem.settings, 2));
        break;
    }
  }
}
