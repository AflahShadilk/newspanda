import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:newspanda/core/network/network_info.dart';
import 'package:newspanda/features/data/data%20source/news_remote_data_source.dart';
import 'package:newspanda/features/data/repository/repository_impl.dart';
import 'package:newspanda/features/domain/repository/news_repository.dart';
import 'package:newspanda/features/domain/usecases/get_top_headlines.dart';
import 'package:newspanda/features/domain/usecases/search_articles.dart';
import 'package:newspanda/features/presentation/bloc/news_bloc.dart';

final sl=GetIt.instance;
Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => NewsBloc(
      getTopHeadlines: sl(),
      searchArticles: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTopHeadlines(sl()));
  sl.registerLazySingleton(() => SearchArticles(sl()));

  // Repository
  sl.registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
      ));

  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
      () => NewsRemoteDataSourceImpl(client: sl()));

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External 
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}