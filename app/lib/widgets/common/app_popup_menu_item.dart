part of 'app_popup_menu_button.dart';

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
