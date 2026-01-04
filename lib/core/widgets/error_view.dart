import 'package:flutter/material.dart';
import 'package:movie_app/core/constants/app_strings.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_dimens.dart';

/// A reusable error view widget with retry functionality
class ErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final IconData icon;
  final String? retryText;

  const ErrorView({
    super.key,
    this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.retryText,
  });

  /// Factory constructor for network errors
  factory ErrorView.network({
    VoidCallback? onRetry,
  }) {
    return ErrorView(
      message: AppStrings.networkError,
      onRetry: onRetry,
      icon: Icons.wifi_off,
    );
  }

  /// Factory constructor for timeout errors
  factory ErrorView.timeout({
    VoidCallback? onRetry,
  }) {
    return ErrorView(
      message: AppStrings.timeoutError,
      onRetry: onRetry,
      icon: Icons.access_time,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spacing32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.redLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.redLight,
              ),
            ),
            const SizedBox(height: AppDimens.spacing24),

            // Error Title
            Text(
              'Oops!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: AppDimens.spacing12),

            // Error Message
            Text(
              message ?? AppStrings.genericError,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.grayDark,
              ),
            ),
            const SizedBox(height: AppDimens.spacing32),

            // Retry Button
            if (onRetry != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 20),
                  label: Text(retryText ?? AppStrings.retry),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redLight,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spacing24,
                      vertical: AppDimens.spacing16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A compact inline error widget for smaller spaces
class InlineErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const InlineErrorView({
    super.key,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spacing16),
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.spacing16),
      decoration: BoxDecoration(
        color: AppColors.redLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        border: Border.all(
          color: AppColors.redLight.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.redLight,
            size: 24,
          ),
          const SizedBox(width: AppDimens.spacing12),
          Expanded(
            child: Text(
              message ?? AppStrings.genericError,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.redLight,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spacing12,
                ),
              ),
              child: Text(AppStrings.retry),
            ),
        ],
      ),
    );
  }
}
