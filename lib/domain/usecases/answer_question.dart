import 'package:broom/domain/entities/item.dart';
import 'package:broom/domain/entities/play_pile.dart';
import 'package:broom/domain/entities/question.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/errorhandling/failures.dart';
import '../repositories/declutter_repo.dart';

class AnswerQuestion {
  final DeclutterRepo repo;

  AnswerQuestion(this.repo);

  Future<Either<Failure, bool>> execute({
    @required int questionId,
    @required int itemId,
    @required Answer answer,
  }) async {
    final either = await repo.answerQuestion(questionId, itemId, answer);
    return either.fold(
      (failure) => Left(failure),
      (success) => Right(success),
    );
  }
}
