import 'package:dartz/dartz.dart';
import 'package:newspanda/core/errors/failures.dart';
import 'package:newspanda/features/domain/entities/article_model.dart';

abstract class NewsRepository {
  Future<Either<Failure,List<ArticleModel>>>getTopHeadlines({
    required String category,
  });
  Future<Either<Failure, List<ArticleModel>>> searchArticles({
    required String query,
  });
}