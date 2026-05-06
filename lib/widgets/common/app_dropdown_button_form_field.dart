part of 'app_dropdown_button.dart';

/// Themed [DropdownButtonFormField]: [AppTextStyles.body], transparent trigger
/// ink, elevated menu shadow. The Flutter dropdown route cannot draw a menu
/// border; use [AppDropdownButton] where a bordered panel is required.
class AppDropdownButtonFormField<T> extends StatelessWidget {
  const AppDropdownButtonFormField({
    super.key,
    required this.items,
    required this.onChanged,
    this.initialValue,
    this.hint,
    this.disabledHint,
    this.selectedItemBuilder,
    this.onTap,
    this.elevation,
    this.style,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24,
    this.isDense = true,
    this.isExpanded = false,
    this.itemHeight,
    this.focusColor,
    this.focusNode,
    this.autofocus = false,
    this.dropdownColor,
    this.decoration,
    this.onSaved,
    this.validator,
    this.errorBuilder,
    this.forceErrorText,
    this.autovalidateMode,
    this.menuMaxHeight,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius,
    this.padding,
    this.barrierDismissible = true,
    this.mouseCursor,
    this.dropdownMenuItemMouseCursor,
  });

  final List<DropdownMenuItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final T? initialValue;
  final Widget? hint;
  final Widget? disabledHint;
  final DropdownButtonBuilder? selectedItemBuilder;
  final VoidCallback? onTap;
  final int? elevation;
  final TextStyle? style;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double iconSize;
  final bool isDense;
  final bool isExpanded;
  final double? itemHeight;
  final Color? focusColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? dropdownColor;
  final InputDecoration? decoration;
  final FormFieldSetter<T>? onSaved;
  final FormFieldValidator<T>? validator;
  final FormFieldErrorBuilder? errorBuilder;
  final String? forceErrorText;
  final AutovalidateMode? autovalidateMode;
  final double? menuMaxHeight;
  final bool? enableFeedback;
  final AlignmentGeometry alignment;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool barrierDismissible;
  final MouseCursor? mouseCursor;
  final MouseCursor? dropdownMenuItemMouseCursor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final menuBg =
        dropdownColor ?? theme.cardTheme.color ?? theme.colorScheme.surface;
    final radius = borderRadius ?? BorderRadius.circular(16);

    return Theme(
      data: _transparentInkTheme(theme),
      child: DropdownButtonFormField<T>(
        items: items,
        onChanged: onChanged,
        initialValue: initialValue,
        hint: hint,
        disabledHint: disabledHint,
        selectedItemBuilder: selectedItemBuilder,
        onTap: onTap,
        elevation: elevation ?? 8,
        style: style ?? AppTextStyles.body,
        icon: icon,
        iconDisabledColor: iconDisabledColor,
        iconEnabledColor: iconEnabledColor,
        iconSize: iconSize,
        isDense: isDense,
        isExpanded: isExpanded,
        itemHeight: itemHeight,
        focusColor: focusColor ?? Colors.transparent,
        focusNode: focusNode,
        autofocus: autofocus,
        dropdownColor: menuBg,
        decoration: decoration,
        onSaved: onSaved,
        validator: validator,
        errorBuilder: errorBuilder,
        forceErrorText: forceErrorText,
        autovalidateMode: autovalidateMode,
        menuMaxHeight: menuMaxHeight,
        enableFeedback: enableFeedback,
        alignment: alignment,
        borderRadius: radius,
        padding: padding,
        barrierDismissible: barrierDismissible,
        mouseCursor: mouseCursor,
        dropdownMenuItemMouseCursor: dropdownMenuItemMouseCursor,
      ),
    );
  }
}
