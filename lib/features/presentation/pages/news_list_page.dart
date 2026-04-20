// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newspanda/core/theme/app_theme.dart';
import 'package:newspanda/features/presentation/bloc/news_bloc.dart';
import 'package:newspanda/features/presentation/bloc/news_event.dart';
import 'package:newspanda/features/presentation/bloc/news_state.dart';
import 'package:newspanda/features/presentation/pages/article_web_view_page.dart';
import 'package:newspanda/features/presentation/widgets/article_card.dart';
import 'package:newspanda/features/presentation/widgets/category_chip_bar.dart';
import 'package:newspanda/features/presentation/widgets/news_error_widget.dart';
import 'package:newspanda/features/presentation/widgets/news_loading_widget.dart';
import 'package:newspanda/features/presentation/widgets/search_bar_widgets.dart';



class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<NewsBloc>().add(const FetchTopHeadlinesEvent());

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: SafeArea(
        child: BlocConsumer<NewsBloc, NewsState>(
          listener: (context, state) {
            if (state is NewsErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppTheme.errorColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(12),
                ),
              );
            }
          },
          buildWhen: (prev, curr) => curr != prev,
          builder: (context, state) {
            return NestedScrollView(
              headerSliverBuilder: (_, __) => [
                SliverToBoxAdapter(child: _header()),
                SliverToBoxAdapter(
                  child: SearchBarWidget(
                    onSearch: (q) =>
                        context.read<NewsBloc>().add(SearchArticlesEvent(query: q)),
                    onClear: () =>
                        context.read<NewsBloc>().add(const ClearSearchEvent()),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _CategoryBarDelegate(
                    child: Container(
                      color: AppTheme.bgPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CategoryChipBar(
                        activeCategory: state is NewsLoadedState
                            ? state.activeCategory
                            : 'technology',
                        onCategorySelected: (category) =>
                            context.read<NewsBloc>().add(
                                  FetchTopHeadlinesEvent(category: category),
                                ),
                      ),
                    ),
                  ),
                ),
              ],
              body: _body(context, state),
            );
          },
        ),
      ),
    );
  }

  //  Header
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(),
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'Top Headlines',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  height: 1.2,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.accentPrimary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppTheme.accentPrimary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  //  Body
  Widget _body(BuildContext context, NewsState state) {
    if (state is NewsInitialState || state is NewsLoadingState) {
      return const NewsLoadingWidget();
    }
    if (state is NewsErrorState) {
      return NewsErrorWidget(
        message: state.message,
        onRetry: () =>
            context.read<NewsBloc>().add(const FetchTopHeadlinesEvent()),
      );
    }
    if (state is NewsLoadedState) {
      return state.articles.isEmpty
          ? _emptyState()
          : _articleList(context, state);
    }
    return const SizedBox.shrink();
  }

  // Article list
  Widget _articleList(BuildContext context, NewsLoadedState state) {
    return RefreshIndicator(
      color: AppTheme.accentPrimary,
      backgroundColor: AppTheme.bgCard,
      onRefresh: () async {
        context
            .read<NewsBloc>()
            .add(FetchTopHeadlinesEvent(category: state.activeCategory));
        await Future.delayed(const Duration(milliseconds: 800));
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: state.articles.length,
        itemBuilder: (context, index) {
          final article = state.articles[index];
          return ArticleCard(
            article: article,
            isFeatured: index == 0,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ArticleWebViewPage(
                  url: article.url,
                  title: article.sourceName,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  //Empty state 
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppTheme.bgCard,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.newspaper_rounded,
              size: 38,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No articles found',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try a different category or search term',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  //Helper 
  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }
}


class _CategoryBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  const _CategoryBarDelegate({required this.child});

  @override
  Widget build(_, __, ___) => child;
  @override
  double get maxExtent => 60;
  @override
  double get minExtent => 60;
  @override
  bool shouldRebuild(_) => true;
}