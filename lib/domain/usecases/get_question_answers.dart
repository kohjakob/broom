import 'package:broom/domain/entities/item.dart';
import 'package:broom/domain/entities/question.dart';
import 'package:dartz/dartz.dart';

import '../../core/errorhandling/failures.dart';
import '../entities/room.dart';
import '../repositories/declutter_repo.dart';

class GetQuestionAnswers {
  final DeclutterRepo repo;

  GetQuestionAnswers(this.repo);

  Future<Either<Failure, Map<Question, Answer>>> execute(int itemId) async {
    final either = await repo.getQuestionAnswers(itemId);
    return either.fold(
      (failure) => Left(failure),
      (questionAnswers) => Right(questionAnswers),
    );
  }
}
