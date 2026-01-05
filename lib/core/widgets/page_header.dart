import 'package:flutter/material.dart';
import '../theme/app_dimens.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? highlightedText;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.highlightedText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pagePaddingHorizontal,
        vertical: AppDimens.pagePaddingVertical,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: tt.headlineMedium,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppDimens.spacing8),
            Text(
              subtitle! + (highlightedText != null ? ' $highlightedText' : ''),
              style: tt.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
