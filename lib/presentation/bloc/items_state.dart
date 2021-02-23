part of 'items_bloc.dart';

abstract class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object> get props => [];
}

class ItemsNotLoaded extends ItemsState {}

class ItemsLoading extends ItemsState {}

abstract class ItemsLoaded extends ItemsState {
  final List<Item> allItems;
  final List<Item> itemsToDisplay;
  ItemsLoaded(this.allItems, this.itemsToDisplay);

  @override
  List<Object> get props => [...allItems, ...itemsToDisplay];
}

class AddItemFailed extends ItemsState {}

class GetItemsFailed extends ItemsState {}

class ItemsSortedChronological extends ItemsLoaded {
  ItemsSortedChronological(allItems, itemsToDisplay)
      : super(allItems, itemsToDisplay);

  @override
  List<Object> get props => [...itemsToDisplay, ...allItems];
}

class ItemsSortedAscAlpha extends ItemsLoaded {
  ItemsSortedAscAlpha(allItems, itemsToDisplay)
      : super(allItems, itemsToDisplay);

  @override
  List<Object> get props => [...itemsToDisplay, ...allItems];
}

class ItemsSortedDescAlpha extends ItemsLoaded {
  ItemsSortedDescAlpha(allItems, itemsToDisplay)
      : super(allItems, itemsToDisplay);

  @override
  List<Object> get props => [...itemsToDisplay, ...allItems];
}
