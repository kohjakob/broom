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
      yield await _getItemsEvent(event, state);
    }
  }

  Future<ItemsState> _addItemEvent(AddItemEvent event, state) async {
    var either;
    either = await addItem.execute(
      name: event.name,
      description: event.description,
      imagePath: event.imagePath,
    );

    return await either.fold((failure) async {
      return AddItemFailed();
    }, (item) async {
      either = await getItems.execute();
      return either.fold(
        (failure) {
          return GetItemsFailed();
        },
        (items) {
          return ItemsLoaded(items, item);
        },
      );
    });
  }

  Future<ItemsState> _getItemsEvent(event, state) async {
    var either;
    either = await getItems.execute();

    return await either.fold(
      (failure) {
        return GetItemsFailed();
      },
      (items) {
        return ItemsLoaded(items);
      },
    );
  }
}
