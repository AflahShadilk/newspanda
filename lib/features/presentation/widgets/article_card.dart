// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newspanda/core/theme/app_theme.dart';
import 'package:newspanda/core/utils/date_format.dart';
import 'package:newspanda/features/domain/entities/article_entity.dart';


class ArticleCard extends StatelessWidget {
  final ArticleEntity article;
  final VoidCallback onTap;
  final bool isFeatured;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    return isFeatured ? _featuredCard() : _compactCard();
  }

  Widget _featuredCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.divider, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null) _image(height: 200),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sourceRow(),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (article.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      article.description!,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  _dateRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _compactCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sourceRow(),
                  const SizedBox(height: 6),
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _dateRow(),
                ],
              ),
            ),
            if (article.urlToImage != null) ...[
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => _imagePlaceholder(80, 80),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _image({required double height}) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: CachedNetworkImage(
        imageUrl: article.urlToImage!,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => _imagePlaceholder(double.infinity, height),
      ),
    );
  }

  Widget _imagePlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: AppTheme.bgSecondary,
      child: const Icon(Icons.article_outlined, color: AppTheme.textMuted, size: 28),
    );
  }

  Widget _sourceRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.accentPrimary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            article.sourceName,
            style: const TextStyle(
              color: AppTheme.accentPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateRow() {
    return Row(
      children: [
        const Icon(Icons.schedule_rounded, size: 12, color: AppTheme.textMuted),
        const SizedBox(width: 4),
        Text(
          DateFormatter.format(article.publishedAt),
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        const Icon(Icons.arrow_forward_ios_rounded, size: 11, color: AppTheme.textMuted),
      ],
    );
  }
}