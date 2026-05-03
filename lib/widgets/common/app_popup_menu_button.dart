import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

/// Surah Planner popup menu: matches [ThemeData.cardTheme] surface and shape,
/// no M3 surface tint, [AppTextStyles.body] for labels.
class AppPopupMenuButton<T> extends StatelessWidget {
  const AppPopupMenuButton({
    super.key,
    required this.itemBuilder,
    this.onSelected,
    this.onCanceled,
    this.enabled = true,
    this.tooltip,
    this.offset,
    this.initialValue,
    this.splashRadius,
    this.padding = const EdgeInsets.all(8),
    this.child,
    this.icon,
  }) : assert(
         child == null || icon == null,
         'Cannot supply both child and icon.',
       );

  final PopupMenuItemBuilder<T> itemBuilder;
  final PopupMenuItemSelected<T>? onSelected;
  final PopupMenuCanceled? onCanceled;
  final bool enabled;
  final String? tooltip;
  final Offset? offset;
  final T? initialValue;
  final double? splashRadius;
  final EdgeInsetsGeometry padding;
  final Widget? child;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardShape = theme.cardTheme.shape;
    final bodyLabel = WidgetStatePropertyAll<TextStyle?>(AppTextStyles.body);
    final mergedMenuTheme = theme.popupMenuTheme.copyWith(
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      color: theme.cardTheme.color,
      shape:
          cardShape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: theme.dividerTheme.color ?? theme.colorScheme.outline,
            ),
          ),
      textStyle: AppTextStyles.body,
      labelTextStyle: bodyLabel,
    );

    final triggerIcon =
        icon ??
        Icon(
          Icons.more_vert_rounded,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
        );

    return Theme(
      data: theme.copyWith(popupMenuTheme: mergedMenuTheme),
      child: PopupMenuButton<T>(
        enabled: enabled,
        itemBuilder: itemBuilder,
        onSelected: onSelected,
        onCanceled: onCanceled,
        tooltip: tooltip,
        offset: offset ?? Offset.zero,
        initialValue: initialValue,
        splashRadius: splashRadius,
        padding: padding,
        icon: child != null ? null : triggerIcon,
        child: child,
      ),
    );
  }
}

/// [PopupMenuItem] with app label typography; set [destructive] for
/// [ColorScheme.error] text (e.g. delete).
class AppPopupMenuItem<T> extends PopupMenuItem<T> {
  AppPopupMenuItem({
    super.key,
    required super.value,
    required Widget child,
    super.onTap,
    super.enabled,
    super.height,
    super.padding,
    bool destructive = false,
  }) : super(
         child: Builder(
           builder: (context) {
             final base = AppTextStyles.body;
             final style = destructive
                 ? base.copyWith(color: Theme.of(context).colorScheme.error)
                 : base;
             return DefaultTextStyle.merge(style: style, child: child);
           },
         ),
       );
}
