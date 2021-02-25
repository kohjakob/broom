import 'package:broom/core/errorhandling/exceptions.dart';
import 'package:broom/domain/entities/room.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:broom/domain/repositories/declutter_repo.dart';
import 'package:broom/core/errorhandling/failures.dart';
import 'package:broom/domain/entities/item.dart';

class AddItem {
  final DeclutterRepo repo;

  AddItem(this.repo);

  Future<Either<Failure, Item>> execute({
    @required String name,
    @required String description,
    @required String imagePath,
    @required Room room,
  }) async {
    try {
      final item = Item(
        name: name,
        description: description,
        imagePath: imagePath,
        roomId: (room != null) ? room.id : -1,
      );
      final either = await repo.addItem(item);
      return either.fold(
        (failure) => Left(failure),
        (item) => Right(item),
      );
    } on InsufficientItemInfoException {
      return Left(Failure(Code.InsufficientItemInfo));
    }
  }
}
