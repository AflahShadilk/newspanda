import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newspanda/core/theme/app_theme.dart';
import 'package:newspanda/features/presentation/bloc/web_view_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';


class ArticleWebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const ArticleWebViewPage({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<ArticleWebViewPage> createState() => _ArticleWebViewPageState();
}

class _ArticleWebViewPageState extends State<ArticleWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<WebViewCubit>();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppTheme.bgPrimary)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress:         (p) => cubit.onProgress(p),
          onPageStarted:      (_) => cubit.onPageStarted(),
          onPageFinished:     (_) => cubit.onPageFinished(),
          onWebResourceError: (_) => cubit.onPageError(),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebViewCubit, WebViewState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppTheme.bgPrimary,
          appBar: AppBar(
            backgroundColor: AppTheme.bgSecondary,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded, color: AppTheme.textPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              widget.title,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.open_in_browser_rounded,
                  color: AppTheme.textSecondary,
                ),
                onPressed: _openInBrowser,
                tooltip: 'Open in browser',
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(3),
              child: AnimatedOpacity(
                opacity: state.isLoading ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: LinearProgressIndicator(
                  value: state.progress / 100,
                  backgroundColor: AppTheme.bgCard,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppTheme.accentPrimary,
                  ),
                  minHeight: 3,
                ),
              ),
            ),
          ),
          body: WebViewWidget(controller: _controller),
        );
      },
    );
  }

  Future<void> _openInBrowser() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}