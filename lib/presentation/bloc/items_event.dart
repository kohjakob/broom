part of 'items_bloc.dart';

abstract class ItemsEvent extends Equatable {
  const ItemsEvent();

  @override
  List<Object> get props => [];
}

class AddItemEvent extends ItemsEvent {
  final String name;
  final String description;

  AddItemEvent(this.name, this.description) : super();

  @override
  List<Object> get props => [name, description];
}

class GetItemsEvent extends ItemsEvent {
  GetItemsEvent() : super();

  @override
  List<Object> get props => [];
}
