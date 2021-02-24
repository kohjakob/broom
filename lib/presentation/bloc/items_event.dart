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
  final int roomId;

  AddItemEvent(this.name, this.description, [this.imagePath, this.roomId])
      : super();

  @override
  List<Object> get props => [name, description];
}

class GetItemsEvent extends ItemsEvent {}

class SortItemsAscAlphaEvent extends ItemsEvent {}

class SortItemsDescAlphaEvent extends ItemsEvent {}

class SortChronologicalEvent extends ItemsEvent {}

class SearchByLettersEvent extends ItemsEvent {
  final String query;

  SearchByLettersEvent(this.query) : super();

  @override
  List<Object> get props => [query];
}
