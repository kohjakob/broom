import 'package:broom/domain/entities/item.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../core/errorhandling/failures.dart';
import '../repositories/declutter_repo.dart';

class EditItem {
  final DeclutterRepo repo;

  EditItem(this.repo);

  Future<Either<Failure, Item>> execute({
    @required int itemId,
    @required String name,
    @required String description,
    @required int roomId,
    @required String imagePath,
  }) async {
    final item = Item(
      id: itemId,
      name: (name == "") ? "Untitled" : name,
      description: (description == "") ? "No description" : description,
      roomId: roomId,
      imagePath: imagePath,
    );

    final either = await repo.editItem(item);

    return either.fold(
      (failure) => Left(failure),
      (item) => Right(item),
    );
  }
}
