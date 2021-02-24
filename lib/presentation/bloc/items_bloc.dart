import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:broom/domain/entities/item.dart';
import 'package:broom/domain/usecases/add_item.dart';
import 'package:broom/domain/usecases/get_items.dart';
import 'package:equatable/equatable.dart';

part 'items_event.dart';
part 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final GetItems getItems;
  final AddItem addItem;

  ItemsBloc(this.getItems, this.addItem) : super(ItemsNotLoaded()) {
    this.add(GetItemsEvent());
  }

  @override
  Stream<ItemsState> mapEventToState(
    ItemsEvent event,
  ) async* {
    if (event is AddItemEvent) {
      yield await _addItemEvent(event, state);
    }
    if (event is GetItemsEvent) {
      yield ItemsLoading();
      yield await _getItemsEvent(event, state);
    }
    if (event is SortItemsAscAlphaEvent) {
      yield await _sortItemsAscAlphaEvent(event, state);
    }
    if (event is SortItemsDescAlphaEvent) {
      yield await _sortItemsDescAlphaEvent(event, state);
    }
    if (event is SortChronologicalEvent) {
      yield await _sortItemsChronologicalEvent(event, state);
    }
    if (event is SearchByLettersEvent) {
      yield await _searchByLettersEvent(event, state);
    }
  }

  Future<ItemsState> _addItemEvent(AddItemEvent event, state) async {
    var either;
    either = await addItem.execute(
      name: event.name,
      description: event.description,
      imagePath: event.imagePath,
      roomId: event.roomId,
    );

    return await either.fold((failure) async {
      return AddItemFailed();
    }, (item) async {
      add(GetItemsEvent());
    });
  }

  Future<ItemsState> _getItemsEvent(event, state) async {
    var either;
    either = await getItems.execute();

    return await either.fold(
      (failure) {
        return GetItemsFailed();
      },
      (itemsToDisplay) {
        return ItemsSortedChronological(itemsToDisplay, itemsToDisplay);
      },
    );
  }

  Future<ItemsState> _sortItemsAscAlphaEvent(event, state) async {
    if (state != ItemsNotLoaded) {
      var sortedItems = state.itemsToDisplay.toList();
      sortedItems.sort((Item l, Item r) => l.name.compareTo(r.name));
      return ItemsSortedAscAlpha(state.allItems, sortedItems);
    } else {
      return ItemsNotLoaded();
    }
  }

  Future<ItemsState> _sortItemsDescAlphaEvent(event, state) async {
    if (state != ItemsNotLoaded) {
      var sortedItems = state.itemsToDisplay.toList();
      sortedItems.sort((Item l, Item r) => r.name.compareTo(l.name));
      return ItemsSortedDescAlpha(state.allItems, sortedItems);
    } else {
      return ItemsNotLoaded();
    }
  }

  Future<ItemsState> _sortItemsChronologicalEvent(event, state) async {
    if (state != ItemsNotLoaded) {
      var sortedItems = state.itemsToDisplay.toList();
      sortedItems.sort((Item l, Item r) => r.id.compareTo(l.id));
      return ItemsSortedChronological(state.allItems, sortedItems);
    } else {
      return ItemsNotLoaded();
    }
  }

  Future<ItemsState> _searchByLettersEvent(event, state) async {
    if (state is ItemsLoaded) {
      var currentItems = state.allItems;
      if (event.query != "") {
        currentItems = state.allItems.toList();
        currentItems.retainWhere((item) =>
            item.name.toLowerCase().contains(event.query.toLowerCase()));
      }
      if (state is ItemsSortedAscAlpha) {
        currentItems.sort((Item l, Item r) => l.name.compareTo(r.name));
        return ItemsSortedAscAlpha(state.allItems, currentItems);
      }
      if (state is ItemsSortedDescAlpha) {
        currentItems.sort((Item l, Item r) => r.name.compareTo(l.name));
        return ItemsSortedDescAlpha(state.allItems, currentItems);
      }
      if (state is ItemsSortedChronological) {
        currentItems.sort((Item l, Item r) => r.id.compareTo(l.id));
        return ItemsSortedChronological(state.allItems, currentItems);
      }
    } else {
      return ItemsNotLoaded();
    }
  }
}
