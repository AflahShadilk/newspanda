import 'package:dartz/dartz.dart';
import 'package:newspanda/core/errors/failures.dart';
import 'package:newspanda/features/domain/entities/article_entity.dart';
import 'package:newspanda/features/domain/repository/news_repository.dart';

class GetTopHeadlines {
  final NewsRepository repository;
  GetTopHeadlines(this.repository);

  Future<Either<Failure, List<ArticleEntity>>> call( String category) {
    return repository.getTopHeadlines(category: category);
  }
}