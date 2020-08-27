part of 'check_box_list_bloc.dart';

abstract class CheckBoxListState extends Equatable {
  const CheckBoxListState();

  @override
  List<Object> get props => [];
}

class CheckBoxListInitial extends CheckBoxListState {}

class CheckBoxListOpen extends CheckBoxListState {}

class CheckBoxListDone extends CheckBoxListState {
  final Map<Object, bool> map;

  const CheckBoxListDone(this.map);

  @override
  List<Object> get props => [map];
}
