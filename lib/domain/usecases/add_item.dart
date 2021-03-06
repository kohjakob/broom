import '../../core/errorhandling/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import '../repositories/declutter_repo.dart';
import '../../core/errorhandling/failures.dart';
import '../entities/item.dart';

class AddItem {
  final DeclutterRepo repo;

  AddItem(this.repo);

  Future<Either<Failure, Item>> execute({
    @required String name,
    @required String description,
    @required String imagePath,
    @required int roomId,
  }) async {
    try {
      final item = Item(
        name: (name == "") ? "Untitled" : name,
        description: (description == "") ? "No description" : description,
        imagePath: imagePath,
        roomId: (roomId != null) ? roomId : -1,
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
