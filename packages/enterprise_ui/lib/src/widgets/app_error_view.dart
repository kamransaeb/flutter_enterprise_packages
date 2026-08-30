import 'package:enterprise_ui/enterprise_ui.dart';
import 'package:flutter/material.dart';

/// Shared error view.
class AppErrorView extends StatelessWidget {

  /// Creates a new [AppErrorView].
  const AppErrorView({
    required this.title,
    required this.message,
    super.key,
    this.icon = Icons.error_outline,
    this.retryLabel,
    this.onRetry,
  });

  /// Headline (app / l10n).
  final String title;

  /// Supporting copy (app / 10n).
  final String message;

  /// Leading icon.
  final IconData icon;

  /// retryLabel ?? 'Retry' is a last-resort fallback; pass 'Retry'.tr() from 
  /// the app when you wire l10n. 
  final String? retryLabel;

  /// Optional button callback.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              AppButton(
                label: retryLabel ?? 'Retry',
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
