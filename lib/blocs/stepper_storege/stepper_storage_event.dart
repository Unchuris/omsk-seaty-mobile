part of 'stepper_storage_bloc.dart';

abstract class StepperStorageEvent extends Equatable {
  const StepperStorageEvent();

  @override
  List<Object> get props => [];
}

class AddImagePath extends StepperStorageEvent {
  final String imagePath;
  final double lat;
  final double lon;
  final String name;
  final String address;
  const AddImagePath(
      {this.imagePath, this.address, this.lat, this.lon, this.name});

  @override
  List<Object> get props => [imagePath, address, lat, lon, name];
}

class AddFeature extends StepperStorageEvent {
  final Map<Object, bool> features;
  const AddFeature({this.features});

  @override
  List<Object> get props => [features];
}

class AddComment extends StepperStorageEvent {
  final String text;
  final int rating;
  const AddComment({this.text, this.rating});

  @override
  List<Object> get props => [text, rating];
}

class RequestEvent extends StepperStorageEvent {
  const RequestEvent();

  @override
  List<Object> get props => [];
}
