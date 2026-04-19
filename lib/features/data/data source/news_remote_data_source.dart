import 'dart:convert';

import 'package:newspanda/core/constants/api_constants.dart';
import 'package:newspanda/core/errors/exceptions.dart';
import 'package:newspanda/features/data/model/article_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines({required String category});
  Future<List<ArticleModel>> searchArticles({required String query});
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;

  NewsRemoteDataSourceImpl({required this.client});

  String get _apiKey=>dotenv.env['NEWS_API_KEY']??'';

  @override
  Future<List<ArticleModel>> getTopHeadlines({required String category}) async {
    final uri= Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.topHeadlinesEndPoint}'
      '?country=${ApiConstants.countryCode}&category=$category&pageSize=20&apiKey=$_apiKey',
    );
    return _fetchArticles(uri);
  }

  @override
  Future<List<ArticleModel>> searchArticles({required String query}) async {
    final uri=Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.everythingEndPoint}'
      '?q=$query&sortBy=publishedAt&pageSize=20&language=en&apiKey=$_apiKey',
    );
    return _fetchArticles(uri);
  }

  Future<List<ArticleModel>>_fetchArticles(Uri uri)async{
    try{
      final response= await client.get(uri,headers: {'Content-Type':'application/json'});
      if(response.statusCode==200){
        final json=jsonDecode(response.body) as Map<String,dynamic>;
        final articlesJson=json['articles'] as List<dynamic>;
        return articlesJson.map((e)=>ArticleModel.fromJson(e as Map<String,dynamic>)).where((a)=>a.title!='[removed]'&&a.url.isNotEmpty).toList();
      }else if(response.statusCode==401){
        throw const ServerExceptions(message: 'Invalid API key. Please check your .env file.');
      }else{
        throw ServerExceptions(message: 'Server error: ${response.statusCode}');
      }
    }on ServerExceptions{
      rethrow;
    }catch (e){
      throw ServerExceptions(message: e.toString());
    }
  }
}