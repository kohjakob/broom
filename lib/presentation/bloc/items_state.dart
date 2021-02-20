part of 'items_bloc.dart';

abstract class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object> get props => [];
}

class ItemsNotLoaded extends ItemsState {}

class ItemsLoaded extends ItemsState {
  final List<Item> items;
  final Item justAdded;

  ItemsLoaded(this.items, [this.justAdded]);

  @override
  List<Object> get props => [items, justAdded];
}

class AddItemFailed extends ItemsState {}

class GetItemsFailed extends ItemsState {}
