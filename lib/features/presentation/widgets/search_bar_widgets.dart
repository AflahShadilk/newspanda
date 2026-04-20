import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newspanda/core/theme/app_theme.dart';
import 'package:newspanda/features/presentation/bloc/search_cubit.dart';


class SearchBarWidget extends StatefulWidget {
  final void Function(String query) onSearch;
  final VoidCallback onClear;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    required this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      context.read<SearchBarCubit>().onTextChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear(BuildContext context) {
    _controller.clear();
    context.read<SearchBarCubit>().clear();
    widget.onClear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBarCubit(),
      child: BlocBuilder<SearchBarCubit, bool>(
        builder: (context, hasText) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: hasText ? AppTheme.accentPrimary : AppTheme.divider,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search global news...',
                  hintStyle: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppTheme.textMuted,
                    size: 20,
                  ),
                  suffixIcon: hasText
                      ? IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppTheme.textMuted,
                            size: 18,
                          ),
                          onPressed: () => _clear(context),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onSubmitted: (q) {
                  if (q.trim().isNotEmpty) widget.onSearch(q.trim());
                },
              ),
            ),
          );
        },
      ),
    );
  }
}