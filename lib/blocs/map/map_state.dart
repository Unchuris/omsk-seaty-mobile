part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();
}

class MapInitial extends MapState {
  const MapInitial();
  @override
  List<Object> get props => [];
}

class MarkersInitial extends MapState {
  const MarkersInitial();
  @override
  List<Object> get props => [];
}
