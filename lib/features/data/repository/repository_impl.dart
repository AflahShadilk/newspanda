import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:newspanda/core/errors/exceptions.dart';
import 'package:newspanda/core/errors/failures.dart';
import 'package:newspanda/core/network/network_info.dart';
import 'package:newspanda/features/data/data%20source/news_remote_data_source.dart';
import 'package:newspanda/features/domain/entities/article_entity.dart';
import 'package:newspanda/features/domain/repository/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository{
  final NewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure,List<ArticleEntity>>>getTopHeadlines({required String category})async{
    return _excuteRequest(() => remoteDataSource.getTopHeadlines(category: category));
  }
  @override
  Future<Either<Failure,List<ArticleEntity>>> searchArticles({required String query})async{
    return _excuteRequest(() => remoteDataSource.searchArticles(query: query));
  }

  Future<Either<Failure,List<ArticleEntity>>>_excuteRequest(Future<List<ArticleEntity>>Function()request)async{
    final isConnected= await networkInfo.isConnected;
    if(!isConnected){
      return const Left(NetworkFailure());
    }
    try{
      final article=await request();
      return Right(article);
    } on ServerExceptions catch (e){
      return Left(ServerFailure(message: e.message));

    }on SocketException{
      return const Left(NetworkFailure());
    }catch (e){
      return Left(ServerFailure(message: e.toString()));
    }
  }
}