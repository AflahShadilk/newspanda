class ServerExceptions implements Exception{
  final String message;
  const ServerExceptions({this.message='A server error occurred.'});
}

class NetworkExceptions implements Exception{
  final String message;
  const NetworkExceptions({this.message='No internet connection.'});
}

class CacheException implements Exception{
  final String message;
  const CacheException({this.message = 'Cache error occurred.'});
}
