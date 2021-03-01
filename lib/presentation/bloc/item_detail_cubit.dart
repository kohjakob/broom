import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/room.dart';

class ItemDetailCubit extends Cubit<ItemDetailState> {
  ItemDetailCubit() : super(ItemDetailLoading());

  setItem(Item item, Room roomOfItem) async {
    emit(ItemDetailLoaded(item, roomOfItem));
  }

  setEmptyItem(Room roomOfItem) async {
    emit(
      ItemDetailLoaded(
        Item(
          name: "My item",
          description: "Used for playing the drums",
          id: 0,
          imagePath: "None",
          roomId: roomOfItem?.id,
        ),
        (roomOfItem != null) ? roomOfItem : null,
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
      emit(ItemDetailLoaded(newItem, previous.roomOfItem));
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
      emit(ItemDetailLoaded(newItem, previous.roomOfItem));
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
      emit(ItemDetailLoaded(newItem, previous.roomOfItem));
    }
  }

  setRoom(Room room) {
    if (state is ItemDetailLoaded) {
      final previous = state as ItemDetailLoaded;
      final newItem = Item(
        name: previous.item.name,
        description: previous.item.description,
        id: previous.item.id,
        imagePath: previous.item.imagePath,
        roomId: room.id,
      );
      emit(ItemDetailLoaded(newItem, previous.roomOfItem));
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
  final Room roomOfItem;

  ItemDetailLoaded(this.item, this.roomOfItem);

  @override
  List<Object> get props => [
        item,
        roomOfItem,
      ];
}
