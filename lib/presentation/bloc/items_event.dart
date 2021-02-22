part of 'items_bloc.dart';

abstract class ItemsEvent extends Equatable {
  const ItemsEvent();

  @override
  List<Object> get props => [];
}

class AddItemEvent extends ItemsEvent {
  final String name;
  final String description;
  final String imagePath;

  AddItemEvent(this.name, this.description, [this.imagePath]) : super();

  @override
  List<Object> get props => [name, description];
}

class GetItemsEvent extends ItemsEvent {
  GetItemsEvent() : super();
}

class SortItemsAscAlphaEvent extends ItemsEvent {
  SortItemsAscAlphaEvent() : super();
}

class SortItemsDescAlphaEvent extends ItemsEvent {
  SortItemsDescAlphaEvent() : super();
}

class SortChronologicalEvent extends ItemsEvent {
  SortChronologicalEvent() : super();
}
