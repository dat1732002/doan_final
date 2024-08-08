import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottom_navigation_state.freezed.dart';

@freezed
class BottomNavigationState with _$BottomNavigationState {
  const factory BottomNavigationState({
    @Default(0) int currentIndex,
  }) = _BottomNavigationState;
}