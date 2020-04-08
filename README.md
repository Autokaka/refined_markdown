# Refined Markdown

[![pub-mirror-cn](https://img.shields.io/badge/dynamic/json?color=blue&label=pub-mirror-cn&query=latestStableVersion&url=https%3A%2F%2Fdart-pub.mirrors.sjtug.sjtu.edu.cn%2Fapi%2Fdocumentation%2Frefined_markdown)](https://dart-pub.mirrors.sjtug.sjtu.edu.cn/packages/refined_markdown) [![pub](https://img.shields.io/badge/dynamic/json?color=blue&label=pub&query=latestStableVersion&url=https%3A%2F%2Fpub.dartlang.org%2Fapi%2Fdocumentation%2Frefined_markdown)](https://pub.dartlang.org/packages/refined_markdown) ![travis](https://travis-ci.org/Autokaka/refined_markdown.svg?branch=master)

## What is it?

A simple Markdown renderer that is written mostly in dart (grammar analysing and rendering part).

## Demo preview

![demo1](https://raw.githubusercontent.com/Autokaka/refined_markdown/master/assets/demo1.jpg) ![demo2](https://raw.githubusercontent.com/Autokaka/refined_markdown/master/assets/demo2.jpg) ![demo3](https://raw.githubusercontent.com/Autokaka/refined_markdown/master/assets/demo3.jpg) ![demo4](https://raw.githubusercontent.com/Autokaka/refined_markdown/master/assets/demo4.jpg) ![demo5](https://raw.githubusercontent.com/Autokaka/refined_markdown/master/assets/demo5.jpg)

## How to use it?

Using RefinedMarkdown is simple. What you need to do is generally like this:

```dart
// main.dart
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:refined_markdown/refined_markdown.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MarkdownPage(),
    );
  }
}

class MarkdownPage extends StatefulWidget {
  @override
  _MarkdownPageState createState() => _MarkdownPageState();
}

class _MarkdownPageState extends State<MarkdownPage> {
  String filePath = 'assets/markdown.html';

  @override
  Widget build(BuildContext context) {
    CSS baseCSS = CSS();
    baseCSS.fontSize = 13;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Markdown测试'),
      ),
      body: RefinedMarkdown(
        text: r"""
        Contents that are written in Markdown format
				""",
        css: baseCSS,
      ),
    );
  }
}
```

**The key part of the code above is:**

```dart
@override
  Widget build(BuildContext context) {
    CSS baseCSS = CSS();
    baseCSS.fontSize = 13;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Markdown测试'),
      ),
      body: RefinedMarkdown(
        text: r"""
        Contents that are written in Markdown format
        """,
        css: baseCSS,
      ),
    );
  }
```

## What are the meanings of those params?

### RefinedMarkdown

| param | type   | explanation                                                                                                                                                                                                                                                             | is required |
| ----- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| text  | String | The **raw** text of a markdown string, please notice that.                                                                                                                                                                                                              | yes         |
| css   | CSS    | The cascading style sheet (in concept) that helps you **build the basic style** of your markdown texts to be rendered. In detail, The rendered text style like the style of “## header2” will be rendered on the basis of the basic style (baseCSS in code demo above). | yes         |

### CSS

| param           | type  | default value      | explanation                                   | is required |
| --------------- | ----- | ------------------ | --------------------------------------------- | ----------- |
| fontSize        | int   | 11                 | The size of the text                          | no          |
| fontColor       | Color | Colors.black87     | The color of the text                         | no          |
| backgroundColor | Color | Colors.transparent | The color of the background of **each** text  | no          |
| isItalic        | bool  | false              | Whether the text is displayed in bold style   | no          |
| isBold          | bool  | false              | Whether the text is displayed in italic style | no          |
| deleted         | bool  | false              | Whether the text is shown with line-through   | no          |
| underline       | bool  | false              | Whether to show an underline                  | no          |
