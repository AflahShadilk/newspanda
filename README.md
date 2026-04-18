# 📰 Flutter News Reader App

A production-ready Flutter news reader application built with **BLoC state management** and **Clean Architecture** principles. Fetches real-time top headlines from [NewsAPI](https://newsapi.org/) and displays them in a beautiful, category-filtered list with in-app web browsing.

---

## 📋 Table of Contents

- [Features](#features)
- [Architecture Overview](#architecture-overview)
- [Project Structure](#project-structure)
- [Tech Stack & Dependencies](#tech-stack--dependencies)
- [Getting Started](#getting-started)
- [API Setup](#api-setup)
- [Layer Breakdown](#layer-breakdown)
- [BLoC Flow](#bloc-flow)
- [Screens & Navigation](#screens--navigation)
- [Error Handling](#error-handling)
- [Environment Variables](#environment-variables)
- [Testing Plan](#testing-plan)
- [Future Improvements](#future-improvements)

---

## ✨ Features

- 🔍 Fetch top headlines from NewsAPI (real-time)
- 🗂️ Filter news by category: Technology, Sports, Business, Health, Science, Entertainment
- 📰 Display article title, description, source name, and formatted publish date
- 🌐 Open full article in an in-app WebView or external browser
- ⏳ Loading indicator while fetching data
- ❌ Graceful error handling with user-friendly messages
- 🔄 Pull-to-refresh support
- 📱 Responsive and visually appealing UI

---

## 🏛️ Architecture Overview

This app follows **Clean Architecture** by Robert C. Martin ("Uncle Bob"), adapted for Flutter. The codebase is separated into three distinct layers:

```
┌──────────────────────────────────────────────┐
│              PRESENTATION LAYER               │
│   (Flutter Widgets + BLoC State Management)  │
├──────────────────────────────────────────────┤
│                DOMAIN LAYER                   │
│     (Entities, Use Cases, Repositories)       │
├──────────────────────────────────────────────┤
│                  DATA LAYER                   │
│  (API Client, Models, Repository Impl, Cache) │
└──────────────────────────────────────────────┘
```

**Key Principle:** Dependencies only point **inward**. The domain layer has zero knowledge of Flutter, HTTP, or any external framework.

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart        # Base URL, endpoints, API key ref
│   │   └── app_strings.dart          # UI string constants
│   ├── errors/
│   │   ├── exceptions.dart           # Custom exceptions (ServerException, etc.)
│   │   └── failures.dart             # Failure sealed classes
│   ├── network/
│   │   └── network_info.dart         # Internet connectivity checker
│   └── utils/
│       └── date_formatter.dart       # Date formatting utility
│
├── features/
│   └── news/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── news_remote_data_source.dart   # NewsAPI HTTP calls
│       │   ├── models/
│       │   │   └── article_model.dart             # JSON serializable model
│       │   └── repositories/
│       │       └── news_repository_impl.dart      # Concrete repository
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── article.dart                   # Pure Dart entity
│       │   ├── repositories/
│       │   │   └── news_repository.dart           # Abstract repository
│       │   └── usecases/
│       │       └── get_top_headlines.dart         # Business logic
│       │
│       └── presentation/
│           ├── bloc/
│           │   ├── news_bloc.dart
│           │   ├── news_event.dart
│           │   └── news_state.dart
│           ├── pages/
│           │   ├── news_list_page.dart            # Main headlines list
│           │   └── article_webview_page.dart      # In-app browser
│           └── widgets/
│               ├── article_card.dart              # News list item card
│               ├── category_chip_bar.dart         # Category filter row
│               ├── news_error_widget.dart         # Error state UI
│               └── news_loading_widget.dart       # Loading shimmer UI
│
├── injection_container.dart          # GetIt dependency injection setup
└── main.dart                         # App entry point
```

---

## 🛠️ Tech Stack & Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | ^8.1.3 | BLoC state management |
| `equatable` | ^2.0.5 | Value equality for BLoC states/events |
| `http` | ^1.1.0 | REST API calls to NewsAPI |
| `get_it` | ^7.6.4 | Service locator / Dependency Injection |
| `webview_flutter` | ^4.4.2 | In-app article viewer |
| `url_launcher` | ^6.2.1 | Open articles in external browser |
| `cached_network_image` | ^3.3.0 | Article thumbnail image caching |
| `shimmer` | ^3.0.0 | Loading placeholder animations |
| `intl` | ^0.18.1 | Date formatting |
| `connectivity_plus` | ^5.0.2 | Network connectivity check |
| `flutter_dotenv` | ^5.1.0 | Secure API key management |
| `dartz` | ^0.10.1 | Functional programming (Either type) |

Add these to your `pubspec.yaml` under `dependencies`.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- A free API key from [newsapi.org](https://newsapi.org/register)
- Android Studio / VS Code with Flutter extension

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/flutter-news-reader.git
cd flutter-news-reader

# 2. Install dependencies
flutter pub get

# 3. Create your .env file (see API Setup below)
touch .env

# 4. Run the app
flutter run
```

---

## 🔑 API Setup

1. Register at [https://newsapi.org/register](https://newsapi.org/register) to get a free API key.
2. Create a `.env` file in the project root:

```env
NEWS_API_KEY=your_api_key_here
BASE_URL=https://newsapi.org/v2
```

3. Add `.env` to your `pubspec.yaml` assets:

```yaml
flutter:
  assets:
    - .env
```

4. Load it in `main.dart`:

```dart
await dotenv.load(fileName: ".env");
```

> ⚠️ **Never commit your `.env` file.** Add it to `.gitignore` immediately.

---

## 🧩 Layer Breakdown

### 1. Domain Layer (Core Business Logic)

**Entity** — `article.dart`
```dart
class Article extends Equatable {
  final String title;
  final String? description;
  final String sourceName;
  final String publishedAt;
  final String url;
  final String? urlToImage;

  const Article({ required this.title, this.description,
    required this.sourceName, required this.publishedAt,
    required this.url, this.urlToImage });

  @override
  List<Object?> get props => [title, url];
}
```

**Repository Contract** — `news_repository.dart`
```dart
abstract class NewsRepository {
  Future<Either<Failure, List<Article>>> getTopHeadlines({
    required String category,
  });
}
```

**Use Case** — `get_top_headlines.dart`
```dart
class GetTopHeadlines {
  final NewsRepository repository;
  GetTopHeadlines(this.repository);

  Future<Either<Failure, List<Article>>> call(String category) {
    return repository.getTopHeadlines(category: category);
  }
}
```

---

### 2. Data Layer

**Model** — `article_model.dart` extends `Article` entity with `fromJson` factory.

**Remote Data Source** — `news_remote_data_source.dart` handles raw HTTP calls to NewsAPI.

**Repository Implementation** — `news_repository_impl.dart` bridges the data source to the domain, catches exceptions, and returns `Either<Failure, List<Article>>`.

---

### 3. Presentation Layer (BLoC)

**Events** — `news_event.dart`
```dart
abstract class NewsEvent extends Equatable {}

class FetchTopHeadlines extends NewsEvent {
  final String category;
  const FetchTopHeadlines({this.category = 'technology'});
  @override List<Object> get props => [category];
}
```

**States** — `news_state.dart`
```dart
abstract class NewsState extends Equatable {}

class NewsInitial extends NewsState { ... }
class NewsLoading extends NewsState { ... }
class NewsLoaded  extends NewsState { final List<Article> articles; ... }
class NewsError   extends NewsState { final String message; ... }
```

**BLoC** — `news_bloc.dart`
```dart
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetTopHeadlines getTopHeadlines;

  NewsBloc({required this.getTopHeadlines}) : super(NewsInitial()) {
    on<FetchTopHeadlines>(_onFetchTopHeadlines);
  }

  Future<void> _onFetchTopHeadlines(
    FetchTopHeadlines event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    final result = await getTopHeadlines(event.category);
    result.fold(
      (failure) => emit(NewsError(message: failure.message)),
      (articles) => emit(NewsLoaded(articles: articles)),
    );
  }
}
```

---

## 🔄 BLoC Flow

```
User taps category chip
        │
        ▼
FetchTopHeadlines Event dispatched
        │
        ▼
NewsBloc receives event → emits NewsLoading
        │
        ▼
GetTopHeadlines UseCase called
        │
        ▼
NewsRepositoryImpl → NewsRemoteDataSource → NewsAPI HTTP call
        │
   ┌────┴────┐
   │         │
Success    Failure
   │         │
   ▼         ▼
NewsLoaded  NewsError
   │         │
   ▼         ▼
Article   Error message
  List      Widget
displayed  displayed
```

---

## 📱 Screens & Navigation

| Screen | Description |
|---|---|
| `NewsListPage` | Main screen with category chips and scrollable article cards |
| `ArticleWebViewPage` | Loads the full article URL in an in-app WebView |

### Navigation

```dart
// From NewsListPage → ArticleWebViewPage
Navigator.push(context, MaterialPageRoute(
  builder: (_) => ArticleWebViewPage(url: article.url),
));
```

---

## ❌ Error Handling

| Scenario | Exception | Failure | UI Message |
|---|---|---|---|
| No internet | `SocketException` | `NetworkFailure` | "No internet connection. Please check your network." |
| API error (4xx/5xx) | `ServerException` | `ServerFailure` | "Unable to load news. Please try again later." |
| Invalid/missing API key | `ServerException` (401) | `ServerFailure` | "API key error. Contact support." |
| Empty response | — | `ServerFailure` | "No articles found for this category." |

All failures are surfaced using the `dartz` `Either` type — **no uncaught exceptions** reach the UI.

---

## 🔐 Environment Variables

| Variable | Description |
|---|---|
| `NEWS_API_KEY` | Your NewsAPI key from newsapi.org |
| `BASE_URL` | `https://newsapi.org/v2` |

---

## 🧪 Testing Plan

```
test/
├── features/
│   └── news/
│       ├── data/
│       │   ├── datasources/news_remote_data_source_test.dart
│       │   └── repositories/news_repository_impl_test.dart
│       ├── domain/
│       │   └── usecases/get_top_headlines_test.dart
│       └── presentation/
│           └── bloc/news_bloc_test.dart
└── helpers/
    └── test_helper.dart
```

- **Unit Tests**: Use cases, repository, data source (mock HTTP with `mocktail`)
- **BLoC Tests**: Using `bloc_test` package to verify state transitions
- **Widget Tests**: Article card rendering, error/loading state widgets

---

## 🚧 Future Improvements

- [ ] Offline caching with `hive` or `sqflite`
- [ ] Search functionality across articles
- [ ] Bookmark / save articles locally
- [ ] Dark mode support
- [ ] Pagination / infinite scroll
- [ ] Push notifications for breaking news
- [ ] Multi-language support with `flutter_localizations`

---

## 📄 License

This project is built as a company machine task assessment. All rights reserved.

---

## 👨‍💻 Author

Built with ❤️ using Flutter + BLoC + Clean Architecture.