import 'package:bloc/bloc.dart';
import 'package:broom/domain/entities/item.dart';
import 'package:broom/domain/entities/room.dart';
import 'package:broom/domain/usecases/add_item.dart';
import 'package:broom/domain/usecases/add_room.dart';
import 'package:broom/domain/usecases/get_rooms.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum ItemSorting { AscendingAlphaName, DescendingAlphaName, AscendingDate }

class DisplayItem {
  Item item;
  bool searchMatch;
  bool roomFilterMatch;

  DisplayItem(this.item, this.searchMatch, this.roomFilterMatch);
}

class GridCubit extends Cubit<GridState> {
  final GetRooms getRoomsUsecase;
  final AddRoom addRoomUsecase;
  final AddItem addItemUsecase;

  GridCubit(this.getRoomsUsecase, this.addRoomUsecase, this.addItemUsecase)
      : super(GridLoading()) {
    fetchRooms();
  }

  addRoom(String name, String description) async {
    emit(GridLoading());
    final either = await addRoomUsecase.execute(
      name: name,
      description: description,
    );
    either.fold(
      (failure) {
        emit(GridFailed());
      },
      (room) {
        fetchRooms();
      },
    );
  }

  addItem(String name, String description, String imagePath,
      Room roomToAddTo) async {
    emit(GridLoading());
    final either = await addItemUsecase.execute(
      name: name,
      description: description,
      imagePath: imagePath,
      roomId: roomToAddTo.id,
    );
    either.fold(
      (failure) {
        emit(GridFailed());
      },
      (item) {
        fetchRooms();
      },
    );
  }

  fetchRooms() async {
    emit(GridLoading());
    var either = await getRoomsUsecase.execute();
    either.fold(
      (failure) {
        emit(GridFailed());
      },
      (rooms) {
        final items =
            rooms.map((room) => room.items).expand((item) => item).toList();
        var displayItems =
            items.map((item) => DisplayItem(item, true, true)).toList();
        displayItems.sort((a, b) => a.item.id.compareTo(b.item.id));
        emit(GridLoaded(
          rooms: rooms,
          displayItems: displayItems,
          sorting: ItemSorting.AscendingDate,
          searchQuery: "",
          roomSelected: null,
        ));
      },
    );
  }

  sortItems(ItemSorting sorting) {
    if (state is GridLoaded) {
      final previousState = (state as GridLoaded);
      final displayItems = previousState.displayItems;
      switch (sorting) {
        case ItemSorting.AscendingAlphaName:
          displayItems.sort((a, b) => a.item.name.compareTo(b.item.name));
          break;
        case ItemSorting.DescendingAlphaName:
          displayItems.sort((a, b) => b.item.name.compareTo(a.item.name));
          break;
        case ItemSorting.AscendingDate:
          displayItems.sort((a, b) => a.item.id.compareTo(b.item.id));
          break;
      }

      final sortedDisplayItems = displayItems;

      emit(GridLoaded(
        rooms: previousState.rooms,
        displayItems: sortedDisplayItems,
        roomSelected: previousState.roomSelected,
        searchQuery: previousState.searchQuery,
        sorting: sorting,
      ));
    }
  }

  searchItems(String query) {
    if (state is GridLoaded) {
      final previousState = (state as GridLoaded);
      final displayItems = previousState.displayItems;

      final searchedDisplayItems = displayItems.map((displayItem) {
        // If query is empty all items match
        if (query == "") {
          displayItem.searchMatch = true;
        } else {
          // If query is not empty set searchMatch to true for the DisplayItems where name contains query
          if (displayItem.item.name.contains(query)) {
            displayItem.searchMatch = true;
          }
          // If name of DisplayItem doesnt contain query set searchMatch to false
          else {
            displayItem.searchMatch = false;
          }
        }
        return displayItem;
      }).toList();

      emit(GridLoaded(
        rooms: previousState.rooms,
        displayItems: searchedDisplayItems,
        roomSelected: previousState.roomSelected,
        searchQuery: query,
        sorting: previousState.sorting,
      ));
    }
  }

  filterItems(Room room) {
    if (state is GridLoaded) {
      final previousState = (state as GridLoaded);
      final displayItems = previousState.displayItems;

      final roomFilteredDisplayItems = displayItems.map((displayItem) {
        if (room == null) {
          displayItem.roomFilterMatch = true;
        } else {
          if (displayItem.item.roomId == room.id) {
            displayItem.roomFilterMatch = true;
          } else {
            displayItem.roomFilterMatch = false;
          }
        }

        return displayItem;
      }).toList();

      emit(GridLoaded(
        rooms: previousState.rooms,
        displayItems: roomFilteredDisplayItems,
        roomSelected: room,
        searchQuery: previousState.searchQuery,
        sorting: previousState.sorting,
      ));
    }
  }
}

abstract class GridState extends Equatable {
  const GridState();

  @override
  List<Object> get props => [];
}

class GridInitial extends GridState {}

class GridLoading extends GridState {}

class GridFailed extends GridState {}

class GridLoaded extends GridState {
  final List<Room> rooms;
  final List<DisplayItem> displayItems;
  final ItemSorting sorting;
  final String searchQuery;
  final Room roomSelected;

  GridLoaded({
    @required this.rooms,
    @required this.displayItems,
    @required this.sorting,
    @required this.searchQuery,
    @required this.roomSelected,
  });

  @override
  List<Object> get props =>
      [rooms, displayItems, sorting, searchQuery, roomSelected];
}