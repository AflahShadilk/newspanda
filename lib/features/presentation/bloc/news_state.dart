import 'package:equatable/equatable.dart';
import 'package:newspanda/features/domain/entities/article_entity.dart';


abstract class NewsState extends Equatable {
  const NewsState();
  @override
  List<Object> get props => [];
}

class NewsInitialState extends NewsState {
  const NewsInitialState();
}

class NewsLoadingState extends NewsState {
  const NewsLoadingState();
}

class NewsLoadedState extends NewsState {
  final List<ArticleEntity> articles;
  final String activeCategory;
  final bool isSearchResult;

  const NewsLoadedState({
    required this.articles,
    required this.activeCategory,
    this.isSearchResult = false,
  });

  @override
  List<Object> get props => [articles, activeCategory, isSearchResult];
}

class NewsErrorState extends NewsState {
  final String message;
  const NewsErrorState({required this.message});
  @override
  List<Object> get props => [message];
}