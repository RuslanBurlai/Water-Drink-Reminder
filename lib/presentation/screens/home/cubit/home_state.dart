part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoaded extends HomeState {
  final User user;

  HomeLoaded({required this.user});
}
