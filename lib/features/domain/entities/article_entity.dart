import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable{
  final String title;
  final String ? description;
  final String sourceName;
  final String publishedAt;
  final String url;
  final String ? urlToImage;
  final String ? author;

  const ArticleEntity({
    required this.title,
    this.description,
    required this.sourceName,
    required this.publishedAt,
    required this.url,
    this.urlToImage,
    this.author
  });
  
  @override
  List<Object?> get props => [title,description,sourceName,publishedAt,url,urlToImage,author];
}