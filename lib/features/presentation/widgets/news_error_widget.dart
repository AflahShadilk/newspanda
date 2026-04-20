// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:newspanda/core/theme/app_theme.dart';

class NewsErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const NewsErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork = message.toLowerCase().contains('internet') ||
        message.toLowerCase().contains('network');

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isNetwork
                    ? Icons.wifi_off_rounded
                    : Icons.cloud_off_rounded,
                size: 42,
                color: AppTheme.errorColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isNetwork ? 'No Connection' : 'Something Went Wrong',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentPrimary, Color(0xFF8B85FF)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentPrimary.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Try Again',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}