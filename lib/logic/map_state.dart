part of 'map_cubit.dart';

@immutable
sealed class MapState {}

final class MapInitial extends MapState {}
final class SuccessfullyGetCurrentLocation extends MapState {}
