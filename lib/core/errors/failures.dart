import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final String message;
  const Failure({required this.message});
 
  @override
  List<Object> get props => [message]; 
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Unable to load news. Please try again later.'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection. Please check your network.'});
}
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Local data error. Please restart the app.'});
}