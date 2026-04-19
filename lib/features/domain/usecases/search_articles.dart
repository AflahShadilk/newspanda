import 'package:dartz/dartz.dart';
import 'package:newspanda/core/errors/failures.dart';
import 'package:newspanda/features/domain/entities/article_entity.dart';
import 'package:newspanda/features/domain/repository/news_repository.dart';

class SearchArticles {
  final NewsRepository repository;
  SearchArticles(this.repository);

  Future<Either<Failure,List<ArticleEntity>>>call(String query) {
    return repository.searchArticles(query: query);
  }
}