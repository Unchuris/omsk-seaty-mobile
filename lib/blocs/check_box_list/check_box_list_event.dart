part of 'check_box_list_bloc.dart';

abstract class CheckBoxListEvent extends Equatable {
  const CheckBoxListEvent();

  @override
  List<Object> get props => [];
}

class CheckBoxListOpened extends CheckBoxListEvent {}

class CheckBoxListDialogOpened extends CheckBoxListEvent {}

class CheckBoxListChanged extends CheckBoxListEvent {
  final Map<Object, bool> map;

  const CheckBoxListChanged(this.map);

  @override
  List<Object> get props => [map];
}

class CheckBoxItemDelete extends CheckBoxListEvent {
  final Object item;

  const CheckBoxItemDelete({this.item});

  @override
  List<Object> get props => [item];
}

class CheckBoxClouse extends CheckBoxListEvent {
  const CheckBoxClouse();

  @override
  List<Object> get props => [];
}
