part of 'bottom_nav_bar_cubit.dart';

enum BottomNavBarItem { home, settings, profile }

class BottomNavBarState extends Equatable {
  final BottomNavBarItem bottomNavBarItem;
  final int index;

  const BottomNavBarState(this.bottomNavBarItem, this.index);

  @override
  List<Object> get props => [bottomNavBarItem, index];
}
