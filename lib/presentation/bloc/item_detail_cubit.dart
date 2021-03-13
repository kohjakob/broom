import 'package:bloc/bloc.dart';
import 'package:broom/domain/entities/question.dart';
import 'package:broom/domain/usecases/get_question_answers.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/item.dart';

class ItemDetailCubit extends Cubit<ItemDetailState> {
  final GetQuestionAnswers getQuestionAnswersUsecase;

  ItemDetailCubit(this.getQuestionAnswersUsecase) : super(ItemDetailLoading());

  setItem(Item item, int roomId) async {
    final either = await getQuestionAnswersUsecase.execute(item.id);
    either.fold(
      (failure) {},
      (questionAnswers) {
        emit(ItemDetailLoaded(item, questionAnswers));
      },
    );
  }

  setEmptyItem(int roomId) async {
    emit(
      ItemDetailLoaded(
        Item(
          name: "Untitled",
          description: "No description",
          id: 0,
          imagePath: null,
          roomId: (roomId != null) ? roomId : null,
        ),
        {},
      ),
    );
  }

  Future<void> setImage(XFile xFile) async {
    if (state is ItemDetailLoaded) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = join(directory.path, xFile.name);
      // ignore: await_only_futures
      await xFile.saveTo(imagePath);

      final previous = state as ItemDetailLoaded;
      final newItem = Item(
        name: previous.item.name,
        description: previous.item.description,
        id: previous.item.id,
        imagePath: imagePath,
        roomId: previous.item.roomId,
      );
      emit(ItemDetailLoaded(newItem, previous.questionAnswers));
    }
  }

  setName(String name) {
    if (state is ItemDetailLoaded) {
      final previous = state as ItemDetailLoaded;
      final newItem = Item(
        name: name,
        description: previous.item.description,
        id: previous.item.id,
        imagePath: previous.item.imagePath,
        roomId: previous.item.roomId,
      );
      emit(ItemDetailLoaded(newItem, previous.questionAnswers));
    }
  }

  setDescription(String description) {
    if (state is ItemDetailLoaded) {
      final previous = state as ItemDetailLoaded;
      final newItem = Item(
        name: previous.item.name,
        description: description,
        id: previous.item.id,
        imagePath: previous.item.imagePath,
        roomId: previous.item.roomId,
      );
      emit(ItemDetailLoaded(newItem, previous.questionAnswers));
    }
  }

  setRoom(int roomId) {
    if (state is ItemDetailLoaded) {
      final previous = state as ItemDetailLoaded;
      final newItem = Item(
        name: previous.item.name,
        description: previous.item.description,
        id: previous.item.id,
        imagePath: previous.item.imagePath,
        roomId: roomId,
      );
      emit(ItemDetailLoaded(newItem, previous.questionAnswers));
    }
  }
}

abstract class ItemDetailState extends Equatable {
  const ItemDetailState();

  @override
  List<Object> get props => [];
}

class ItemDetailLoading extends ItemDetailState {}

class ItemDetailLoaded extends ItemDetailState {
  final Item item;
  final Map<Question, Answer> questionAnswers;

  ItemDetailLoaded(this.item, this.questionAnswers);

  @override
  List<Object> get props => [
        item,
        item.roomId,
        questionAnswers,
      ];
}
