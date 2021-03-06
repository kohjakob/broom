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
      (items) {
        emit(SwipeLoaded(items));
      },
    );
  }

  swipeLeft() {
    if (state is SwipeLoaded) {
      final previous = state as SwipeLoaded;
      if (previous.items.length > 0) {
        final itemPopped =
            previous.items.getRange(0, previous.items.length - 1).toList();
        emit(SwipeLoaded(itemPopped));
      } else {
        // OHOH
      }
    }
  }

  swipeRight() {
    if (state is SwipeLoaded) {
      final previous = state as SwipeLoaded;
      if (previous.items.length > 0) {
        final itemPopped =
            previous.items.getRange(0, previous.items.length - 1).toList();
        emit(SwipeLoaded(itemPopped));
      } else {
        // OHOH
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

class SwipeLoaded extends SwipeState {
  final List<Item> items;

  SwipeLoaded(this.items);

  @override
  List<Object> get props => [items];
}
