import 'package:bloc/bloc.dart';
import 'package:broom/domain/entities/item.dart';
import 'package:broom/domain/usecases/get_items.dart';
import 'package:equatable/equatable.dart';

class SwipeCubit extends Cubit<SwipeState> {
  final GetItems getItemsUsecase;

  SwipeCubit(this.getItemsUsecase) : super(SwipeInitial()) {
    fetchItems();
  }

  fetchItems() async {
    var either = await getItemsUsecase.execute();
    either.fold(
      (failure) {
        emit(SwipeFailed());
      },
      (allItems) {
        emit(SwipeLoaded(allItems, allItems.first, []));
      },
    );
  }

  swipeLeft(Item swipedItem) {
    if (state is SwipeLoaded) {
      // Remove item from allItems
      final allItems = (state as SwipeLoaded).allItems.toList();
      allItems.removeWhere((item) => item.id == swipedItem.id);
      // Add item to swiped items
      final swipedItems = (state as SwipeLoaded).swipedItems.toList();
      swipedItems.add(swipedItem);
      if (allItems.isEmpty) {
        emit(SwipedThrough());
      } else {
        // New top item
        final topItem = allItems.first;
        emit(SwipeLoaded(allItems, topItem, swipedItems));
      }
    }
  }

  swipeRight(Item swipedItem) {
    if (state is SwipeLoaded) {
      // Remove item from allItems
      final allItems = (state as SwipeLoaded).allItems.toList();
      allItems.removeWhere((item) => item.id == swipedItem.id);
      // Add item to swiped items
      final swipedItems = (state as SwipeLoaded).swipedItems.toList();
      swipedItems.add(swipedItem);
      if (allItems.isEmpty) {
        emit(SwipedThrough());
      } else {
        // New top item
        final topItem = allItems.first;
        emit(SwipeLoaded(allItems, topItem, swipedItems));
      }
    }
  }
}

abstract class SwipeState extends Equatable {
  const SwipeState();

  @override
  List<Object> get props => [];
}

class SwipeInitial extends SwipeState {}

class SwipeFailed extends SwipeState {}

class SwipedThrough extends SwipeState {}

class SwipeLoaded extends SwipeState {
  final List<Item> allItems;
  final List<Item> swipedItems;
  final Item topItem;

  SwipeLoaded(this.allItems, this.topItem, this.swipedItems);

  @override
  List<Object> get props => [allItems, topItem, swipedItems];
}
