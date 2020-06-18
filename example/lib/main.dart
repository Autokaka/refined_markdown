import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:refined_markdown/refined_markdown.dart';

void main() {
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
  String text = "Loading asset string...";

  Future<void> loadDemo() async {
    String demoStr = await rootBundle.loadString('assets/demo.md');
    setState(() => text = demoStr);
  }

  @override
  void initState() {
    super.initState();
    loadDemo();
  }

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
        text: text,
        css: baseCSS,
      ),
    );
  }
}
