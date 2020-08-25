part of 'add_image_bloc.dart';

abstract class AddImageEvent extends Equatable {
  const AddImageEvent();

  @override
  List<Object> get props => [];
}

class AddImageStarted extends AddImageEvent {
  final Widget image;

  const AddImageStarted(this.image);

  @override
  List<Object> get props => [image];
}

class AddImageCanceled extends AddImageEvent {}
