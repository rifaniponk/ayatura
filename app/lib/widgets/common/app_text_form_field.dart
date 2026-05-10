import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Applies [ThemeData.inputDecorationTheme] and Ayatura label, hint, and
/// helper typography. Use with [AppTextFormField] or pass to fields that take
/// an [InputDecoration] (e.g. [DropdownButtonFormField]).
InputDecoration mergeAppInputDecoration(
  BuildContext context, [
  InputDecoration? partial,
]) {
  final theme = Theme.of(context);
  final applied = (partial ?? const InputDecoration()).applyDefaults(
    theme.inputDecorationTheme,
  );

  return applied.copyWith(
    labelStyle:
        applied.labelStyle ??
        AppTextStyles.cardLabel.copyWith(color: AppColors.ink2),
    floatingLabelStyle:
        applied.floatingLabelStyle ??
        WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.error)) {
            return AppTextStyles.cardLabel.copyWith(
              color: theme.colorScheme.error,
            );
          }
          if (states.contains(WidgetState.focused)) {
            return AppTextStyles.cardLabel.copyWith(
              color: AppColors.green2,
              fontWeight: FontWeight.w700,
            );
          }
          return AppTextStyles.cardLabel.copyWith(color: AppColors.ink3);
        }),
    hintStyle:
        applied.hintStyle ?? AppTextStyles.body.copyWith(color: AppColors.ink3),
    helperStyle:
        applied.helperStyle ??
        AppTextStyles.smallLabel.copyWith(color: AppColors.ink2),
    errorStyle:
        applied.errorStyle ??
        AppTextStyles.smallLabel.copyWith(
          color: theme.colorScheme.error,
          height: 1.25,
        ),
    floatingLabelBehavior:
        applied.floatingLabelBehavior ?? FloatingLabelBehavior.auto,
  );
}

/// Ayatura text field: theme borders (14px outline), DM Sans body,
/// [AppColors.green2] caret, and card-style label colours for rest / focus / error.
class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20),
    this.enableInteractiveSelection,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.validator,
    this.onSaved,
    this.autovalidateMode,
    this.forceErrorText,
    this.errorBuilder,
    this.restorationId,
    this.mouseCursor,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.scrollController,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final bool? showCursor;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final AutovalidateMode? autovalidateMode;
  final String? forceErrorText;
  final FormFieldErrorBuilder? errorBuilder;
  final String? restorationId;
  final MouseCursor? mouseCursor;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      controller: controller,
      initialValue: controller != null ? null : initialValue,
      focusNode: focusNode,
      decoration: mergeAppInputDecoration(context, decoration),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      style: style ?? AppTextStyles.body,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      autofocus: autofocus,
      readOnly: readOnly,
      showCursor: showCursor,
      obscuringCharacter: obscuringCharacter,
      obscureText: obscureText,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      onChanged: onChanged,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      enabled: enabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor ?? AppColors.green2,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      buildCounter: buildCounter,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      validator: validator,
      onSaved: onSaved,
      autovalidateMode: autovalidateMode,
      forceErrorText: forceErrorText,
      errorBuilder: errorBuilder,
      restorationId: restorationId,
      mouseCursor: mouseCursor,
      spellCheckConfiguration: spellCheckConfiguration,
      magnifierConfiguration: magnifierConfiguration,
      scrollController: scrollController,
    );
  }
}
