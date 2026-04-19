import 'package:newspanda/features/domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity{
  const ArticleModel({
     required super.title,
     super.description,
      required super.sourceName,
      required super.publishedAt,
      required super.url,
      super.urlToImage,
      super.author
  });

  factory ArticleModel.fromJson(Map<String,dynamic> json){
    return ArticleModel(
      title: json['title'] ?? 'No Title',
      description: json['description'],
      sourceName: json['source']?['name'] ?? 'Unknown Source',
      publishedAt: json['publishedAt'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      author: json['author'],
    );
  } 

  Map<String,dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'source': {'name': sourceName},
      'publishedAt': publishedAt,
      'url': url,
      'urlToImage': urlToImage,
      'author': author,
    };
  }
}