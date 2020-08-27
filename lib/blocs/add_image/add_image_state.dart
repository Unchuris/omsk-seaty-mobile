part of 'add_image_bloc.dart';

abstract class AddImageState extends Equatable {
  const AddImageState();

  @override
  List<Object> get props => [];
}

class AddImageInitial extends AddImageState {}
class AddImageLocationLoading extends AddImageState {
  final String imagePath;

  const AddImageLocationLoading(this.imagePath);

  List<Object> get props => [imagePath];
}

class AddImageSuccess extends AddImageState {
  final String imagePath;
  final String address;
  final GeoPoint geoPoint;

  const AddImageSuccess(this.imagePath, this.address, this.geoPoint);

  @override
  List<Object> get props => [imagePath, address, geoPoint];
}

class AddImageFailture extends AddImageState {}
