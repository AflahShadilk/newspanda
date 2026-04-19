class ApiConstants {
  ApiConstants._();
  static const String baseUrl='https://newsapi.org/v2';
  static const String topHeadlinesEndPoint='/top-headlines';
  static const String everythingEndPoint='/everything';
  static const String countryCode='us';

  static const List<String>categories=[
    'general',
    'technology',
    'sports',
    'business',
    'health',
    'science',
    'entertainment'
  ];
}