import 'package:broom/domain/entities/item.dart';
import 'package:broom/domain/entities/play_pile.dart';
import 'package:dartz/dartz.dart';

import '../../core/errorhandling/failures.dart';
import '../repositories/declutter_repo.dart';

class GetQuestionPlayPile {
  final DeclutterRepo repo;

  GetQuestionPlayPile(this.repo);

  Future<Either<Failure, PlayPile>> execute() async {
    final either = await repo.getRandomQuestion();
    return either.fold(
      (failure) => Left(failure),
      (randomQuestion) async {
        final either = await repo.getUnansweredItems(randomQuestion.id);
        return either.fold(
          (failure) => Left(failure),
          (unansweredQuestions) {
            return Right(PlayPile(
              question: randomQuestion,
              items: unansweredQuestions,
            ));
          },
        );
      },
    );
  }
}
