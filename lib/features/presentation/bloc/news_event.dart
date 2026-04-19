import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
  @override
  List<Object> get props => [];
}

class FetchTopHeadlinesEvent extends NewsEvent {
  final String category;
  const FetchTopHeadlinesEvent({this.category = 'technology'});
  @override
  List<Object> get props => [category];
}

class SearchArticlesEvent extends NewsEvent {
  final String query;
  const SearchArticlesEvent({required this.query});
  @override
  List<Object> get props => [query];
}

class ClearSearchEvent extends NewsEvent {
  const ClearSearchEvent();
}