import 'package:broom/domain/entities/item.dart';
import 'package:broom/domain/entities/question.dart';
import 'package:equatable/equatable.dart';

class PlayPile extends Equatable {
  final Question question;
  final List<Item> items;

  PlayPile({
    question,
    items,
  })  : this.question = question,
        this.items = items;

  @override
  List<Object> get props => [this.question, this.items];
}
