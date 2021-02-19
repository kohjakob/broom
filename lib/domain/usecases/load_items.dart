import 'package:broom/core/errorhandling/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:broom/domain/repositories/declutter_repo.dart';
import 'package:broom/core/errorhandling/failures.dart';
import 'package:broom/domain/entities/item.dart';

enum SortField { Name, Date, Rating }
enum SortType { Ascending, Descending }

class LoadItems {
  final DeclutterRepo repo;

  LoadItems(this.repo);

  Future<Either<Failure, Item>> execute({
    int lazyOffset = 20,
  }) async {}
}
