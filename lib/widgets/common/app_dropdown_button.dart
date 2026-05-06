import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

part 'app_dropdown_button_form_field.dart';

/// Popup surface for list-style dropdowns: bordered card, elevation shadow,
/// app typography (contrasts with flat overflow menus).
PopupMenuThemeData _raisedDropdownPanelTheme(
  ThemeData theme,
  BorderRadius radius,
) {
  final outline = theme.dividerTheme.color ?? theme.colorScheme.outline;
  final bodyLabel = WidgetStatePropertyAll<TextStyle?>(AppTextStyles.body);
  return theme.popupMenuTheme.copyWith(
    color: theme.cardTheme.color,
    surfaceTintColor: Colors.transparent,
    elevation: 8,
    shadowColor: theme.shadowColor,
    shape: RoundedRectangleBorder(
      borderRadius: radius,
      side: BorderSide(color: outline),
    ),
    textStyle: AppTextStyles.body,
    labelTextStyle: bodyLabel,
  );
}

ThemeData _transparentInkTheme(ThemeData base) {
  return base.copyWith(
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    splashColor: Colors.transparent,
  );
}

/// List-style dropdown implemented with [PopupMenuButton] so the open panel
/// matches app menus: card fill, 16px corners, hairline border, and elevation
/// shadow (Material popup route). The trigger uses transparent ink highlights.
///
/// Parameters such as [underline] are accepted for API parity with
/// [DropdownButton] but ignored here.
class AppDropdownButton<T> extends StatelessWidget {
  const AppDropdownButton({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
    this.disabledHint,
    this.selectedItemBuilder,
    this.onTap,
    this.elevation,
    this.style,
    this.underline,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24,
    this.isDense = false,
    this.isExpanded = false,
    this.itemHeight,
    this.menuWidth,
    this.dropdownColor,
    this.menuMaxHeight,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius,
    this.padding,
    this.dropdownMenuItemMouseCursor,
  });

  final List<DropdownMenuItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final T? value;
  final Widget? hint;
  final Widget? disabledHint;
  final DropdownButtonBuilder? selectedItemBuilder;
  final VoidCallback? onTap;
  final double? elevation;
  final TextStyle? style;
  final Widget? underline;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double iconSize;
  final bool isDense;
  final bool isExpanded;
  final double? itemHeight;
  final double? menuWidth;
  final Color? dropdownColor;
  final double? menuMaxHeight;
  final bool? enableFeedback;
  final AlignmentGeometry alignment;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final MouseCursor? dropdownMenuItemMouseCursor;

  Widget _triggerLabel(BuildContext context, bool enabled) {
    final list = items;
    if (!enabled && disabledHint != null) return disabledHint!;
    if (value == null && hint != null) return hint!;
    if (selectedItemBuilder != null && list != null) {
      final built = selectedItemBuilder!(context);
      final i = list.indexWhere((e) => e.value == value);
      if (i >= 0 && i < built.length) return built[i];
    }
    if (list != null) {
      for (final e in list) {
        if (e.value == value) return e.child;
      }
    }
    return hint ?? const SizedBox.shrink();
  }

  BoxConstraints? _menuConstraints() {
    if (menuWidth != null && menuMaxHeight != null) {
      return BoxConstraints(
        minWidth: menuWidth!,
        maxWidth: menuWidth!,
        maxHeight: menuMaxHeight!,
      );
    }
    if (menuWidth != null) {
      return BoxConstraints(minWidth: menuWidth!, maxWidth: menuWidth!);
    }
    if (menuMaxHeight != null) {
      return BoxConstraints(maxHeight: menuMaxHeight!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final list = items;
    final enabled = list != null && list.isNotEmpty && onChanged != null;
    final menuBg =
        dropdownColor ?? theme.cardTheme.color ?? theme.colorScheme.surface;
    final radius = borderRadius ?? BorderRadius.circular(16);
    final menuShape = RoundedRectangleBorder(
      borderRadius: radius,
      side: BorderSide(
        color: theme.dividerTheme.color ?? theme.colorScheme.outline,
      ),
    );
    final textStyle = style ?? AppTextStyles.body;
    final effectiveIconColor = enabled
        ? (iconEnabledColor ??
              theme.colorScheme.onSurface.withValues(alpha: 0.72))
        : (iconDisabledColor ??
              theme.colorScheme.onSurface.withValues(alpha: 0.38));

    final suffixIcon =
        icon ?? Icon(Icons.arrow_drop_down_rounded, size: iconSize);

    final triggerPadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: isDense ? 4 : 8,
          vertical: isDense ? 2 : 4,
        );

    final rowChildren = <Widget>[
      if (isExpanded)
        Expanded(child: _triggerLabel(context, enabled))
      else
        _triggerLabel(context, enabled),
      SizedBox(width: isDense ? 2 : 4),
      suffixIcon,
    ];

    final popupTheme = _raisedDropdownPanelTheme(theme, radius);

    // PopupMenuButton ignores [padding] when using a custom [child]; apply it here.
    // ListTile.trailing can pass unbounded horizontal constraints — Align+Row then
    // fails layout in slivers; IntrinsicWidth fixes intrinsic sizing when not expanded.
    Widget trigger = Padding(
      padding: triggerPadding,
      child: DefaultTextStyle(
        style: textStyle,
        child: IconTheme.merge(
          data: IconThemeData(size: iconSize, color: effectiveIconColor),
          child: Row(
            mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: rowChildren,
          ),
        ),
      ),
    );
    if (!isExpanded) {
      trigger = IntrinsicWidth(child: trigger);
    } else {
      trigger = Align(alignment: alignment, child: trigger);
    }

    return Theme(
      data: _transparentInkTheme(theme).copyWith(popupMenuTheme: popupTheme),
      child: PopupMenuButton<T>(
        enabled: enabled,
        padding: EdgeInsets.zero,
        initialValue: value,
        onOpened: onTap,
        onSelected: enabled ? (v) => onChanged?.call(v) : null,
        elevation: elevation ?? 8,
        shadowColor: theme.shadowColor,
        surfaceTintColor: Colors.transparent,
        color: menuBg,
        shape: menuShape,
        borderRadius: radius,
        constraints: _menuConstraints(),
        enableFeedback: enableFeedback,
        child: trigger,
        itemBuilder: (ctx) {
          if (list == null) return [];
          return [
            for (final e in list)
              PopupMenuItem<T>(
                value: e.value,
                enabled: e.enabled,
                onTap: e.onTap,
                height: itemHeight ?? kMinInteractiveDimension,
                mouseCursor: dropdownMenuItemMouseCursor,
                child: DefaultTextStyle.merge(
                  style: AppTextStyles.body,
                  child: e.child,
                ),
              ),
          ];
        },
      ),
    );
  }
}
