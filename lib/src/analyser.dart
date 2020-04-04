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
    for (var pattern in supports.keys) {
      RegExp regExp = RegExp(pattern);
      var firstMatch = regExp.firstMatch(text);
      if (firstMatch == null) continue;
      return supports[pattern](
          text, firstMatch.start, firstMatch.end, css, context);
    }

    return (inheritedWidgetBuilder != null)
        ? inheritedWidgetBuilder(text)
        : TextSpan(
            text: text,
            style: css.castStyle(),
          );
  }
}
