import 'dart:math';

import 'package:farmsmart_flutter/data/model/NewStageEntity.dart';
import 'package:farmsmart_flutter/data/model/mock/MockDate.dart';
import 'package:farmsmart_flutter/data/model/mock/MockString.dart';
import 'MockArticle.dart';
import 'MockEntity.dart';

final _identifiers = MockString();
final _articleBuilder = MockArticle();
final _mockDate = MockDate();

class MockStage extends MockEntity<NewStageEntity> {
  final Random _rand;

  MockStage({int seed}) : this._rand = Random(seed);

  NewStageEntity build() {
      final start = _mockDate.randomMonthAgo();
      return NewStageEntity(id: _identifiers.identifier(), article: _articleBuilder.buildStage(), started: start, ended: null);
  }

  //LH here we generate valid stage sequence starting and ending at the input dates, and ending at the input stage
  List<NewStageEntity> sequence({DateTime starting, DateTime ending, bool inProgress = true, int count = 10}) {
      final lastStage = inProgress ? _rand.nextInt(count) : count;
      int start = starting.millisecondsSinceEpoch;
      int end = ending.millisecondsSinceEpoch;
      int expanse = end - start;
      int inc  = expanse ~/ max(1, lastStage).toInt();
      List<NewStageEntity> stages = [];
      int current = start;
      for (var i = 0; i < count; i++) {
        DateTime startDate = DateTime.fromMillisecondsSinceEpoch(current);
        final next = current + inc;
        DateTime endDate = DateTime.fromMillisecondsSinceEpoch(next);
        if (i == lastStage) {
          endDate = ending;
        }
        else if (i > lastStage) {
          startDate = null;
          endDate = null;
        }
        stages.add(NewStageEntity(id: _identifiers.identifier(), article: _articleBuilder.buildStage(), started: startDate, ended: endDate));
        current = next;
      }
    return stages;
  }
}

MockStage _stageBuilder = MockStage();
class MockArticleEntityCollection extends MockEntityCollection<NewStageEntity> {
  MockArticleEntityCollection() : super(_stageBuilder);
}
