part of 'stepper_storage_bloc.dart';

abstract class StepperStorageState extends Equatable {
  const StepperStorageState();

  @override
  List<Object> get props => [];
}

class StepperStorageInitial extends StepperStorageState {}

class AddImagePathState extends StepperStorageState {
  const AddImagePathState();

  @override
  List<Object> get props => [];
}

class AddFeatureState extends StepperStorageState {
  const AddFeatureState();

  @override
  List<Object> get props => [];
}

class AddCommentState extends StepperStorageState {
  const AddCommentState();

  @override
  List<Object> get props => [];
}

class RequestState extends StepperStorageState {
  const RequestState();

  @override
  List<Object> get props => [];
}

class ErrorState extends StepperStorageState {}

class Error403State extends StepperStorageState {}

class SucessState extends StepperStorageState {}
