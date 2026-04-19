import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newspanda/features/domain/usecases/get_top_headlines.dart';
import 'package:newspanda/features/domain/usecases/search_articles.dart';
import 'package:newspanda/features/presentation/bloc/news_event.dart';
import 'package:newspanda/features/presentation/bloc/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetTopHeadlines getTopHeadlines;
  final SearchArticles searchArticles;
  String activeCategory = 'technology';
  NewsBloc({required this.getTopHeadlines, required this.searchArticles})
      : super(const NewsInitialState()) {
        on<FetchTopHeadlinesEvent>(onFetchTopHeadlines);
        on<SearchArticlesEvent>(onSearchArticle);
        on<ClearSearchEvent>(onClearSearch);
      }

  Future<void> onFetchTopHeadlines(
      FetchTopHeadlinesEvent event, Emitter<NewsState> emit) async {
    activeCategory = event.category;
    emit(const NewsLoadingState());
    final result = await getTopHeadlines(event.category);
    result.fold(
        (failure) => emit(NewsErrorState(message: failure.message)),
        (article) => emit(NewsLoadedState(
            articles: article, activeCategory: activeCategory)));
  }

  Future<void> onSearchArticle(
      SearchArticlesEvent event, Emitter<NewsState> emit) async {
    emit(const NewsLoadingState());
    final result = await searchArticles(event.query);
    result.fold(
        (ifleft) => emit(NewsErrorState(message: ifleft.message)),
        (ifRight) => emit(NewsLoadedState(
            articles: ifRight,
            activeCategory: activeCategory,
            isSearchResult: true)));
  }

  Future<void> onClearSearch(
      ClearSearchEvent event, Emitter<NewsState> emit) async {
    add(FetchTopHeadlinesEvent(category: activeCategory));
  }
}
