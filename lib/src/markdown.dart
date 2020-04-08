import 'package:flutter/material.dart';

import './analyser.dart';
import './css.dart';

class RefinedMarkdown extends StatelessWidget {
  final String text;
  final CSS css;

  RefinedMarkdown({
    Key key,
    @required this.text,
    @required this.css,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String processedText = ("\n" + text).replaceAll('\n\n', '\n');
    return SingleChildScrollView(
      child: Text.rich(
        Analyser(
          text: processedText, // 解析器设计上以"\n"为解析起点, 加"\n"才能解析首行
          css: css,
        ).parseTextSpan(context),
      ),
    );
  }
}
