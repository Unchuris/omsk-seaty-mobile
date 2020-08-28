part of 'add_comment_step_bloc.dart';

abstract class AddCommentStepEvent extends Equatable {
  const AddCommentStepEvent();

  @override
  List<Object> get props => [];
}

class CloseTextFieldEvent extends AddCommentStepEvent {
  final String text;
  final int rating;
  const CloseTextFieldEvent({this.rating, this.text});

  @override
  List<Object> get props => [rating, text];
}
