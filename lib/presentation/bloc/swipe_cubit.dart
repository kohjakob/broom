import 'package:bloc/bloc.dart';
import 'package:broom/domain/entities/item.dart';
import 'package:broom/domain/entities/play_pile.dart';
import 'package:broom/domain/entities/question.dart';
import 'package:broom/domain/usecases/answer_question.dart';
import 'package:broom/domain/usecases/get_items.dart';
import 'package:broom/domain/usecases/get_question_play_pile.dart';
import 'package:equatable/equatable.dart';

class SwipeCubit extends Cubit<SwipeState> {
  final GetItems getItemsUsecase;
  final GetQuestionPlayPile getQuestionPlayPileUsecase;
  final AnswerQuestion answerQuestion;

  SwipeCubit(
    this.getItemsUsecase,
    this.getQuestionPlayPileUsecase,
    this.answerQuestion,
  ) : super(SwipeInitial()) {
    fetchPlayPile();
  }

  fetchPlayPile() async {
    var either = await getQuestionPlayPileUsecase.execute();
    either.fold(
      (failure) {
        emit(SwipeFailed());
      },
      (playPile) {
        if (playPile.items.isEmpty) {
          emit(SwipeNoItems());
        } else {
          emit(SwipeLoaded(playPile.items, playPile.items.first, [], playPile));
        }
      },
    );
  }

  swipeLeft(Item swipedItem) {
    if (state is SwipeLoaded) {
      answerQuestion.execute(
        itemId: swipedItem.id,
        questionId: (state as SwipeLoaded).playPile.question.id,
        answer: Answer.No,
      );
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
        final playPile = (state as SwipeLoaded).playPile;
        emit(SwipeLoaded(allItems, topItem, swipedItems, playPile));
      }
    }
  }

  skipCard() {
    if (state is SwipeLoaded) {
      // Remove item from allItems
      final allItems = (state as SwipeLoaded).allItems.toList();
      allItems.removeAt(0);
      // Add item to swiped items
      final swipedItems = (state as SwipeLoaded).swipedItems.toList();
      swipedItems.add((state as SwipeLoaded).allItems.first);
      if (allItems.isEmpty) {
        emit(SwipedThrough());
      } else {
        // New top item
        final topItem = allItems.first;
        final playPile = (state as SwipeLoaded).playPile;
        emit(SwipeLoaded(allItems, topItem, swipedItems, playPile));
      }
    }
  }

  swipeRight(Item swipedItem) {
    if (state is SwipeLoaded) {
      answerQuestion.execute(
        itemId: swipedItem.id,
        questionId: (state as SwipeLoaded).playPile.question.id,
        answer: Answer.Yes,
      );
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
        final playPile = (state as SwipeLoaded).playPile;
        emit(SwipeLoaded(allItems, topItem, swipedItems, playPile));
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

class SwipeNoItems extends SwipeState {}

class SwipeFailed extends SwipeState {}

class SwipedThrough extends SwipeState {}

class SwipeLoaded extends SwipeState {
  final List<Item> allItems;
  final List<Item> swipedItems;
  final Item topItem;
  final PlayPile playPile;

  SwipeLoaded(this.allItems, this.topItem, this.swipedItems, this.playPile);

  @override
  List<Object> get props => [allItems, topItem, swipedItems];
}
