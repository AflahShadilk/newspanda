import 'package:flutter/material.dart';
import 'package:newspanda/core/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class NewsLoadingWidget extends StatelessWidget {
  const NewsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.bgCard,
      highlightColor: AppTheme.bgCardHover,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 6,
        itemBuilder: (_, index) => index == 0
            ? _featuredShimmer()
            : _compactShimmer(),
      ),
    );
  }

  Widget _featuredShimmer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 80, height: 20, radius: 6),
                const SizedBox(height: 10),
                _shimmerBox(width: double.infinity, height: 18),
                const SizedBox(height: 6),
                _shimmerBox(width: double.infinity, height: 18),
                const SizedBox(height: 6),
                _shimmerBox(width: 200, height: 18),
                const SizedBox(height: 14),
                _shimmerBox(width: 100, height: 14, radius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _compactShimmer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 70, height: 18, radius: 6),
                const SizedBox(height: 8),
                _shimmerBox(width: double.infinity, height: 14),
                const SizedBox(height: 5),
                _shimmerBox(width: double.infinity, height: 14),
                const SizedBox(height: 5),
                _shimmerBox(width: 180, height: 14),
                const SizedBox(height: 10),
                _shimmerBox(width: 80, height: 12, radius: 4),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _shimmerBox(width: 80, height: 80, radius: 10),
        ],
      ),
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    double radius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}