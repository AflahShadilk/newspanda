import 'package:dartz/dartz.dart';
import 'package:newspanda/core/errors/failures.dart';
import 'package:newspanda/features/domain/entities/article_entity.dart';

abstract class NewsRepository {
  Future<Either<Failure,List<ArticleEntity>>>getTopHeadlines({
    required String category,
  });
  Future<Either<Failure, List<ArticleEntity>>> searchArticles({
    required String query,
  });
}