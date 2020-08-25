part of 'add_image_bloc.dart';

abstract class AddImageState extends Equatable {
  const AddImageState();

  @override
  List<Object> get props => [];
}

class AddImageInitial extends AddImageState {}

class AddImageSuccess extends AddImageState {
  final Widget image;

  const AddImageSuccess(this.image);

  @override
  List<Object> get props => [image];
}

class AddImageFailture extends AddImageState {}
