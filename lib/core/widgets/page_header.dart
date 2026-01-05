import 'package:flutter/material.dart';
import '../theme/app_dimens.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? highlightedText;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextAlign textAlign;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.highlightedText,
    this.titleStyle,
    this.subtitleStyle,
    this.textAlign = TextAlign.start,
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
        crossAxisAlignment: textAlign == TextAlign.center
            ? CrossAxisAlignment.center
            : textAlign == TextAlign.right || textAlign == TextAlign.end
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle ?? tt.headlineMedium,
            textAlign: textAlign,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppDimens.spacing8),
            Text(
              subtitle! + (highlightedText != null ? ' $highlightedText' : ''),
              style: subtitleStyle?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(
                      alpha: 0.7,
                    ),
                  ) ??
                  tt.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(
                      alpha: 0.7,
                    ),
                  ),
              textAlign: textAlign,
            ),
          ],
        ],
      ),
    );
  }
}
