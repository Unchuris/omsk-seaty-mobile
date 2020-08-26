part of 'add_image_bloc.dart';

abstract class AddImageEvent extends Equatable {
  const AddImageEvent();

  @override
  List<Object> get props => [];
}

class AddImageStarted extends AddImageEvent {
  final String imagePath;

  const AddImageStarted(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class AddImageLocation extends AddImageEvent {
  final GeoPoint location;

  const AddImageLocation(this.location);

  @override
  List<Object> get props => [location];
}

class AddImageCanceled extends AddImageEvent {}
