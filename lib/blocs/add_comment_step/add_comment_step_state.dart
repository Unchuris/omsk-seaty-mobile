part of 'add_comment_step_bloc.dart';

abstract class AddCommentStepState extends Equatable {
  const AddCommentStepState();

  @override
  List<Object> get props => [];
}

class AddCommentStepInitial extends AddCommentStepState {}

class CloseTextFiledState extends AddCommentStepState {
  final String text;
  final int rating;

  const CloseTextFiledState({this.text, this.rating});

  @override
  List<Object> get props => [text, rating];
}
