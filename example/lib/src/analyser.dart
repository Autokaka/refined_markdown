import 'package:flutter/material.dart';
import './css.dart';
import './support.dart';

class Analyser {
  final String text;
  final CSS css;
  final InlineSpan Function(String text) inheritedWidgetBuilder;

  Analyser({
    @required this.text,
    @required this.css,
    this.inheritedWidgetBuilder,
  });

  InlineSpan parseTextSpan(BuildContext context) {
    int start = text.length;
    int end = 0;
    String finPtrn;
    for (var pattern in supports.keys) {
      RegExp regExp = RegExp(pattern);
      var firstMatch = regExp.firstMatch(text);
      if (firstMatch == null) continue;
      if (firstMatch.start < start) {
        start = firstMatch.start;
        end = firstMatch.end;
        finPtrn = pattern;
      }
    }
    if (finPtrn != null) {
      return supports[finPtrn](text, start, end, css, context);
    }

    return (inheritedWidgetBuilder != null)
        ? inheritedWidgetBuilder(text)
        : TextSpan(
            text: text,
            style: css.castStyle(),
          );
  }
}
