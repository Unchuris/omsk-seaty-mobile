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

class CheckBoxItemChange extends CheckBoxListState {
  final Object item;
  final Map<Object, bool> map;
  const CheckBoxItemChange({this.item, this.map});

  @override
  List<Object> get props => [item, map];
}

class CheckBoxPageClosed extends CheckBoxListState {}
