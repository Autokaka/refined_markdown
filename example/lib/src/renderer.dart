import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:highlight/highlight.dart' show highlight, Node;

import './launch.dart';
import './analyser.dart';
import './css.dart';
import './color.dart';

abstract class Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const Renderer({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  });

  InlineSpan build(BuildContext context);
}

class Header extends Renderer {
  final String src;
  final int start;
  final int end;
  final double size;
  final CSS css;

  const Header({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.size,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是: "###### H6"

    // 1. 定位"#####"的位置
    RegExp symbol = RegExp(r"#+");
    var match = symbol.firstMatch(src.substring(start, end));
    int symbolEnd = start + match.end; // 最后一个"#"的后一位

    // 2. 提取关键字符串"H6"
    String keyStr = src.substring(symbolEnd, end).trim();

    // 3. 定义Header的叠加样式
    CSS headerCSS = CSS.copyFrom(css);
    headerCSS.fontSize = size + css.fontSize;
    headerCSS.isBold = true;

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        TextSpan(text: "\n"),
        Analyser(
          text: keyStr,
          css: headerCSS,
        ).parseTextSpan(context),
        Analyser(
          text: src.substring(end, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }
}

class NormalList extends Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const NormalList({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是: "\n     - 常规列表\n"

    // 1. 定位符号"     - "
    RegExp symbolReg = RegExp(r" *- ");
    var match = symbolReg.firstMatch(src.substring(start, end));
    int symbolEnd = start + match.end; // "- "的后一位
    int symbolStart = start + match.start;

    // 2. 将"     - "的缩进加倍
    int spaceCnt = symbolEnd - symbolStart - 2;
    String spacing = " " * spaceCnt * 2;

    // 3. 替换符号"-"
    String symbol = "";
    if (spaceCnt == 0)
      symbol = "● ";
    else if (spaceCnt <= 2)
      symbol = "○ ";
    else if (spaceCnt <= 4)
      symbol = "■ ";
    else
      symbol = "□ ";

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        TextSpan(
          text: "\n" + spacing,
          style: css.castStyle(),
          children: [
            TextSpan(
              text: symbol,
              style: CSS(fontSize: 5).castStyle(),
            ),
          ],
        ),
        Analyser(
          text: src.substring(symbolEnd, end),
          css: css,
        ).parseTextSpan(context),
        Analyser(
          text: src.substring(end, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }
}

class SeqList extends Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const SeqList({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是: "\n     123. 顺序列表\n"

    // 1. 定位符号"123. "
    RegExp symbolReg = RegExp(r"\d+\. ");
    var match = symbolReg.firstMatch(src.substring(start, end));
    int symbolStart = start + match.start; // "1"的位置

    // 2. 将"     123. "的缩进加倍
    int spaceCnt = symbolStart - start - 1;
    String spacing = " " * spaceCnt * 2;

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        TextSpan(
          text: "\n" + spacing,
          style: css.castStyle(),
        ),
        Analyser(
          text: src.substring(symbolStart, end),
          css: css,
        ).parseTextSpan(context),
        Analyser(
          text: src.substring(end, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }
}

class TaskList extends Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const TaskList({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是: "\n      - [ ] 任务列表(未完成)\n"

    // 1. 定位符号"- [ ] "
    RegExp symbolReg = RegExp(r"- \[(x| )\] ");
    var match = symbolReg.firstMatch(src.substring(start, end));
    int symbolStart = start + match.start; // "-"的位置
    int symbolEnd = start + match.end; // "] "空格的后一位置

    // 2. 判断任务是否完成
    String statusStr = src[symbolEnd - 3];
    bool isFinished = (statusStr == "x");
    statusStr = isFinished ? "√ " : "× ";

    // 3. 根据完成情况设定css
    CSS listCSS = CSS.copyFrom(css);
    listCSS.fontColor = isFinished ? Colors.green[300] : Colors.orange;
    listCSS.deleted = isFinished;
    CSS statusCSS = CSS.copyFrom(css);
    statusCSS.fontColor = listCSS.fontColor;

    // 4. 将"     - [ ] "的缩进加倍
    int spaceCnt = symbolStart - start - 1;
    String spacing = " " * spaceCnt * 3;

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        TextSpan(
          text: "\n" + spacing,
          style: css.castStyle(),
          children: [
            TextSpan(
              text: statusStr,
              style: statusCSS.castStyle(),
            ),
          ],
        ),
        Analyser(
          text: src.substring(symbolEnd, end),
          css: listCSS,
        ).parseTextSpan(context),
        Analyser(
          text: src.substring(end, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }
}

class BoldText extends Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const BoldText({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是: "**加 粗 字 体**"

    // 1. 获取关键字"加 粗 字 体"
    String keyStr = src.substring(start + 2, end - 2);

    // 2. 设置关键字的叠加样式
    CSS boldCSS = CSS.copyFrom(css);
    boldCSS.isBold = true;

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        Analyser(
          text: keyStr,
          css: boldCSS,
        ).parseTextSpan(context),
        Analyser(
          text: src.substring(end, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }
}

class BoldItalicText extends Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const BoldItalicText({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是: "**加 粗 字 体**"

    // 1. 获取关键字"加 粗 字 体"
    String keyStr = src.substring(start + 3, end - 3);

    // 2. 设置关键字的叠加样式
    CSS boldItalicCSS = CSS.copyFrom(css);
    boldItalicCSS.isBold = true;
    boldItalicCSS.isItalic = true;

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        Analyser(
          text: keyStr,
          css: boldItalicCSS,
        ).parseTextSpan(context),
        Analyser(
          text: src.substring(end, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }
}

class ItalicText extends Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const ItalicText({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是: "*倾 斜 字 体*"

    // 1. 获取关键字"倾 斜 字 体"
    String keyStr = src.substring(start + 1, end - 1);

    // 2. 设置关键字的叠加样式
    CSS boldCSS = CSS.copyFrom(css);
    boldCSS.isItalic = true;

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        Analyser(
          text: keyStr,
          css: boldCSS,
        ).parseTextSpan(context),
        Analyser(
          text: src.substring(end, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }
}

class CodeBlock extends Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const CodeBlock({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是:
    //      ```   dart
    // void main() => print("Hello world");
    //      ```

    // 1. 获取代码语言"dart"
    // ```   dart
    // void main() => print("Hello world");
    // ```
    RegExp langReg = RegExp(r"`{3}[^\n]*");
    var langMatch = langReg.firstMatch(src.substring(start, end));
    int langStart = start + langMatch.start; // 第一个"`"的位置
    int langEnd = start + langMatch.end; // "dart"行的"\n"位置
    String language = src.substring(langStart + 3, langEnd).trim();

    // 2. 获取代码块内容
    // ```   dart
    // void main() => print("Hello world");
    // ```
    RegExp codeReg = RegExp(r"`{3}[^\n]*");
    var codeMatch = codeReg.allMatches(src.substring(langEnd, end)).last;
    int codeStart = langEnd + 1;
    int codeEnd = langEnd + codeMatch.start;
    String keyStr = src.substring(codeStart, codeEnd);
    keyStr = keyStr.replaceAll('\t', ' ' * 8);

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        TextSpan(text: "\n"),
        TextSpan(
          style: css.castStyle(),
          children: _convert(
            highlight.parse(keyStr, language: language).nodes,
            githubTheme,
          ),
        ),
        Analyser(
          text: src.substring(end, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }

  List<TextSpan> _convert(List<Node> nodes, Map<String, TextStyle> theme) {
    List<TextSpan> spans = [];
    var currentSpans = spans;
    List<List<TextSpan>> stack = [];

    _traverse(Node node) {
      if (node.value != null) {
        currentSpans.add(node.className == null
            ? TextSpan(text: node.value)
            : TextSpan(text: node.value, style: theme[node.className]));
      } else if (node.children != null) {
        List<TextSpan> tmp = [];
        currentSpans.add(TextSpan(children: tmp, style: theme[node.className]));
        stack.add(currentSpans);
        currentSpans = tmp;

        node.children.forEach((n) {
          _traverse(n);
          if (n == node.children.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        });
      }
    }

    for (var node in nodes) {
      _traverse(node);
    }

    return spans;
  }
}

class CodeSegment extends Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const CodeSegment({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是: "`代 码 段`"

    // 1. 获取关键字"代 码 段"
    String keyStr = src.substring(start + 1, end - 1);

    // 2. 设置关键字的叠加样式
    CSS codeSegCSS = CSS.copyFrom(css);
    codeSegCSS.backgroundColor = Colors.grey[300];

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        TextSpan(
          text: " ",
          style: codeSegCSS.castStyle(),
        ),
        Analyser(
          text: keyStr,
          css: codeSegCSS,
        ).parseTextSpan(context),
        TextSpan(
          text: " ",
          style: codeSegCSS.castStyle(),
        ),
        Analyser(
          text: src.substring(end, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }
}

class YAMLDoc extends Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const YAMLDoc({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是:
    //      ---
    // void main() => print("Hello world");
    //      ---

    // 1. 定位YAML起始位置
    RegExp langReg = RegExp(r"-{3} *");
    var langMatch = langReg.firstMatch(src.substring(start, end));
    int langEnd = start + langMatch.end; // "---"行的"\n"位置
    String language = "yaml";

    // 2. 获取YAML内容
    // ---
    // void main() => print("Hello world");
    // ---
    RegExp codeReg = RegExp(r"-{3} *");
    var codeMatch = codeReg.allMatches(src.substring(langEnd, end)).last;
    int codeStart = langEnd + 1;
    int codeEnd = langEnd + codeMatch.start;
    String keyStr = src.substring(codeStart, codeEnd);
    keyStr = keyStr.replaceAll('\t', ' ' * 8);

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        TextSpan(text: "\n"),
        TextSpan(
          style: css.castStyle(),
          children: _convert(
            highlight.parse(keyStr, language: language).nodes,
            githubTheme,
          ),
        ),
        Analyser(
          text: src.substring(end, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }

  List<TextSpan> _convert(List<Node> nodes, Map<String, TextStyle> theme) {
    List<TextSpan> spans = [];
    var currentSpans = spans;
    List<List<TextSpan>> stack = [];

    _traverse(Node node) {
      if (node.value != null) {
        currentSpans.add(node.className == null
            ? TextSpan(text: node.value)
            : TextSpan(text: node.value, style: theme[node.className]));
      } else if (node.children != null) {
        List<TextSpan> tmp = [];
        currentSpans.add(TextSpan(children: tmp, style: theme[node.className]));
        stack.add(currentSpans);
        currentSpans = tmp;

        node.children.forEach((n) {
          _traverse(n);
          if (n == node.children.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        });
      }
    }

    for (var node in nodes) {
      _traverse(node);
    }

    return spans;
  }
}

class Link extends Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const Link({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是: "[链接文字](链接地址)"

    // 1. 获取链接文字
    RegExp wordReg = RegExp(r"\[.*\]");
    var wordMatch = wordReg.firstMatch(src.substring(start, end));
    int wordStart = start + wordMatch.start + 1;
    int wordEnd = start + wordMatch.end - 1;
    String word = src.substring(wordStart, wordEnd).trim();

    // 2. 获取链接地址
    RegExp addrReg = RegExp(r"\(.*\)");
    var addrMatch = addrReg.firstMatch(src.substring(start, end));
    int addrStart = start + addrMatch.start + 1;
    int addrEnd = start + addrMatch.end - 1;
    String addr = src.substring(addrStart, addrEnd).trim();

    // 3. 处理链接文字为空的情况
    if (word == null || word.isEmpty) word = addr;

    // 3. 设置链接文字样式
    CSS wordCSS = CSS.copyFrom(css);
    wordCSS.fontColor = Colors.blue;
    wordCSS.underline = true;

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        Analyser(
          text: word,
          css: wordCSS,
          inheritedWidgetBuilder: (text) {
            return TextSpan(
              text: text,
              style: wordCSS.castStyle(),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  await Launch.getInstance().url(addr);
                },
            );
          },
        ).parseTextSpan(context),
        Analyser(
          text: src.substring(end, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }
}

class MDImage extends Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const MDImage({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是: "![链接文字](图片地址)"

    // 1. 获取链接地址
    RegExp addrReg = RegExp(r"\(.*\)");
    var addrMatch = addrReg.firstMatch(src.substring(start, end));
    int addrStart = start + addrMatch.start + 1;
    int addrEnd = start + addrMatch.end - 1;
    String addr = src.substring(addrStart, addrEnd).trim();

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        WidgetSpan(
          child: Column(
            children: [
              Text("", style: css.castStyle()),
              GestureDetector(
                child: CachedNetworkImage(
                  imageUrl: addr,
                  placeholder: (context, url) => Icon(Icons.arrow_downward),
                  errorWidget: (context, url, error) =>
                      Text("Error: $error\nCannot fetch resource from $url\n"),
                ),
                onTap: () async {
                  await Launch.getInstance().url(addr);
                },
              ),
            ],
          ),
        ),
        Analyser(
          text: src.substring(end, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }
}

class MDDivider extends Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const MDDivider({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是: "\n   ---   "

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        WidgetSpan(
          child: Divider(
            thickness: 1,
            indent: 5,
            endIndent: 5,
          ),
        ),
        Analyser(
          text: src.substring(end, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }
}

class DelLine extends Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const DelLine({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是: "~~删除线~~"

    // 1. 获取关键字"删除线"
    String keyStr = src.substring(start + 2, end - 2);

    // 2. 设置关键字的叠加样式
    CSS delCSS = CSS.copyFrom(css);
    delCSS.deleted = true;

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        Analyser(
          text: keyStr,
          css: delCSS,
        ).parseTextSpan(context),
        Analyser(
          text: src.substring(end, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }
}

class HighlightText extends Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const HighlightText({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是: "==高亮文字=="

    // 1. 获取关键字"高亮文字"
    String keyStr = src.substring(start + 2, end - 2);

    // 2. 设置关键字的叠加样式
    CSS highlightCSS = CSS.copyFrom(css);
    highlightCSS.backgroundColor = Colors.yellow;

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        Analyser(
          text: keyStr,
          css: highlightCSS,
        ).parseTextSpan(context),
        Analyser(
          text: src.substring(end, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }
}

class StyledText extends Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const StyledText({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是: "<font color=red size=12>红色文字, 大小12, 字体常规</font>普通文字<font color=red size=12>红色文字, 大小12, 字体常规</font>"

    // 1. 找到真正的结尾
    int realEnd = end;
    RegExp endExp = RegExp(r"<\/font>");
    var endMatch = endExp.firstMatch(src.substring(start, end));
    realEnd = start + endMatch.end;

    // 2. 获取"红色文字, 大小12, 字体常规"
    RegExp keyReg = RegExp(r">.+<");
    var keyMatch = keyReg.firstMatch(src.substring(start, realEnd));
    String keyStr =
        src.substring(start + keyMatch.start + 1, start + keyMatch.end - 1);

    // 3. 获取关键字"color"的内容
    RegExp colorReg = RegExp(r"color=[^ \n>]+ *");
    var colorMatch = colorReg.firstMatch(src.substring(start, realEnd));
    String colorStr =
        src.substring(start + colorMatch.start + 6, start + colorMatch.end);
    colorStr = colorStr.replaceAll("\"", "").trim();

    // 4. 获取关键字"size"的内容
    RegExp sizeReg = RegExp(r"size=[^ \n>]+ *");
    var sizeMatch = sizeReg.firstMatch(src.substring(start, realEnd));
    String sizeStr =
        src.substring(start + sizeMatch.start + 5, start + sizeMatch.end);

    // 5. 设置关键字的叠加样式
    CSS styledCSS = CSS.copyFrom(css);
    styledCSS.fontColor = SmartColor.getInstance().fromString(colorStr);
    if (colorStr != "transparent" &&
        styledCSS.fontColor == Colors.transparent) {
      try {
        styledCSS.fontColor = Color(int.parse(colorStr));
      } catch (e) {
        styledCSS.fontColor = css.fontColor;
      }
    }
    styledCSS.fontSize = double.parse(sizeStr);

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        Analyser(
          text: keyStr,
          css: styledCSS,
        ).parseTextSpan(context),
        Analyser(
          text: src.substring(realEnd, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }
}

class BreakRow extends Renderer {
  final String src;
  final int start;
  final int end;
  final CSS css;

  const BreakRow({
    Key key,
    @required this.src,
    @required this.start,
    @required this.end,
    @required this.css,
  }) : super(src: src, start: start, end: end, css: css);

  @override
  InlineSpan build(BuildContext context) {
    // 假设提取的字符串是: "<br    />"

    return TextSpan(
      children: [
        Analyser(
          text: src.substring(0, start),
          css: css,
        ).parseTextSpan(context),
        TextSpan(
          text: "\n",
          style: css.castStyle(),
        ),
        Analyser(
          text: src.substring(end, src.length),
          css: css,
        ).parseTextSpan(context),
      ],
    );
  }
}
