import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

/// Inline markup for [TaggedRichText] and [TaggedRichText.inlineSpans].
///
/// Supported pairs (case insensitive on tag names):
/// * `<b>...</b>` bold ([FontWeight.w700] on top of the base style)
/// * `<i>...</i>` or `<em>...</em>` italic
/// * `<u>...</u>` underline
/// * `<s>...</s>`, `<strike>...</strike>`, or `<del>...</del>` strikethrough
///
/// Tags may nest. Unknown tags are shown as plain text. Translators should keep
/// opening and closing tags balanced.
class TaggedRichText extends StatelessWidget {
  const TaggedRichText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaler,
    this.maxLines,
    this.strutStyle,
    this.semanticsLabel,
  });

  /// Copy that may include markup segments such as `<b>...</b>`.
  final String text;

  /// Base style for untagged text and as the foundation for tagged spans.
  /// Defaults to [AppTextStyles.body].
  final TextStyle? style;

  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final StrutStyle? strutStyle;
  final String? semanticsLabel;

  /// Builds [InlineSpan] children. Each span carries a full [TextStyle] for its segment.
  ///
  /// ```dart
  /// Text.rich(
  ///   TextSpan(
  ///     style: baseStyle,
  ///     children: TaggedRichText.inlineSpans(markedCopy, baseStyle),
  ///   ),
  /// )
  /// ```
  static List<InlineSpan> inlineSpans(String markedText, TextStyle base) {
    return _parseToSpans(markedText, base);
  }

  @override
  Widget build(BuildContext context) {
    final base = style ?? AppTextStyles.body;
    return Text.rich(
      TextSpan(style: base, children: _parseToSpans(text, base)),
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler ?? MediaQuery.textScalerOf(context),
      maxLines: maxLines,
      strutStyle: strutStyle,
      semanticsLabel: semanticsLabel,
    );
  }
}

String? _canonicalOpenTag(String raw) {
  switch (raw) {
    case 'b':
      return 'b';
    case 'i':
    case 'em':
      return 'i';
    case 'u':
      return 'u';
    case 's':
    case 'strike':
    case 'del':
      return 's';
    default:
      return null;
  }
}

bool _closingTagMatchesStack(String closeName, String stackTop) {
  switch (closeName) {
    case 'b':
      return stackTop == 'b';
    case 'i':
    case 'em':
      return stackTop == 'i';
    case 'u':
      return stackTop == 'u';
    case 's':
    case 'strike':
    case 'del':
      return stackTop == 's';
    default:
      return false;
  }
}

TextStyle _styleForTagStack(TextStyle base, List<String> stack) {
  if (stack.isEmpty) return base;
  var bold = false;
  var italic = false;
  var underline = false;
  var strike = false;
  for (final t in stack) {
    switch (t) {
      case 'b':
        bold = true;
      case 'i':
        italic = true;
      case 'u':
        underline = true;
      case 's':
        strike = true;
    }
  }
  var result = base;
  if (bold) {
    result = result.copyWith(fontWeight: FontWeight.w700);
  }
  if (italic) {
    result = result.copyWith(fontStyle: FontStyle.italic);
  }
  final extras = <TextDecoration>[];
  if (underline) extras.add(TextDecoration.underline);
  if (strike) extras.add(TextDecoration.lineThrough);
  if (extras.isNotEmpty) {
    final existing = result.decoration;
    final combined = existing != null && existing != TextDecoration.none
        ? TextDecoration.combine([existing, ...extras])
        : TextDecoration.combine(extras);
    result = result.copyWith(decoration: combined);
  }
  return result;
}

List<InlineSpan> _parseToSpans(String input, TextStyle base) {
  final stack = <String>[];
  final pieces = <({String text, List<String> tags})>[];

  var i = 0;
  while (i < input.length) {
    final lt = input.indexOf('<', i);
    if (lt == -1) {
      final rest = input.substring(i);
      if (rest.isNotEmpty) {
        pieces.add((text: rest, tags: List<String>.from(stack)));
      }
      break;
    }
    if (lt > i) {
      pieces.add((
        text: input.substring(i, lt),
        tags: List<String>.from(stack),
      ));
    }
    final gt = input.indexOf('>', lt);
    if (gt == -1) {
      pieces.add((text: input.substring(lt), tags: List<String>.from(stack)));
      break;
    }
    final tagInner = input.substring(lt + 1, gt).trim();
    if (tagInner.startsWith('/')) {
      final closeName = tagInner.substring(1).trim().toLowerCase();
      if (stack.isNotEmpty && _closingTagMatchesStack(closeName, stack.last)) {
        stack.removeLast();
      }
    } else {
      final openName = tagInner.toLowerCase();
      final canon = _canonicalOpenTag(openName);
      if (canon != null) {
        stack.add(canon);
      } else {
        pieces.add((
          text: input.substring(lt, gt + 1),
          tags: List<String>.from(stack),
        ));
      }
    }
    i = gt + 1;
  }

  final merged = <({String text, List<String> tags})>[];
  for (final p in pieces) {
    if (p.text.isEmpty) continue;
    if (merged.isEmpty) {
      merged.add(p);
      continue;
    }
    final last = merged.last;
    if (listEquals(last.tags, p.tags)) {
      merged[merged.length - 1] = (text: last.text + p.text, tags: last.tags);
    } else {
      merged.add(p);
    }
  }

  return merged
      .map(
        (e) => TextSpan(text: e.text, style: _styleForTagStack(base, e.tags)),
      )
      .toList();
}
