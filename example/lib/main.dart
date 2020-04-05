import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

/// If you want to use refined_markdown, please add description in pubspec.yaml
/// and import the package like this:
///
/// import 'package:refined_markdown/refined_markdown.dart';
///
import './refined_markdown.dart';

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
        ###### H6(容错解析)
###### HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH6(折行处理测试)
###H3(无效解析)
###       H3(容错解析)
##### H5
  ## H2
### H3
## H2
##
## H2
# H1

- 普通列表
  - 缩进的普通列表
    - 缩进的普通列表
-普通列表(无效解析)
-     普通列表(容错解析)

##### 标题 - 普通列表(列表无效解析)
- 普通列表 ##### 标题(标题无效解析)

123. 顺序列表
  ###### - 缩进的普通列表(列表无效解析)
  - ###### 标题(标题无效解析)
  123. 缩进的顺序列表
    123. 缩进的顺序列表
    - 缩进的普通列表

- [ ] 任务列表(未完成)
- [x] 任务列表(已完成)
  - [x] 缩进的任务列表(已完成)
    - [ ] 缩进的任务列表(未完成)
- [] 任务列表(无效输入)
- [gkwdnmd] 任务列表(无效输入)

##### 五级标题和**加粗文本**OHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH(效果叠加, 折行容错检测)
**加粗文本**
**加粗文本(无
效解析)*
普通文本和**加粗文本**和普通文本
  **前有空格的加粗文本**
    **前有空格的加粗文本**
    **加粗文本(无效解析, 解析斜体部位)*
普通文本和**加粗文本**和普通文本
##### 五级标题和**加粗文本**

*倾斜文本*普通文本*倾斜文本***加粗文本**普通文本**加粗文本**
  ***加粗倾斜文本***
  *前有空格的倾斜文本*
***加粗倾斜文本***
    ****仅解析加粗倾斜部分****
****仅解析加粗倾斜部分****

```dart
// 代码块
void main() => print("Hello world");
```
          ```dart
          // 缩进的代码块
          void main() => print("Hello world");
            void main() => print("Hello world");
      void main() => print("Hello world");
          void main() => print("Hello world");
          RegExp langReg = RegExp(r"```[^\n]*");
                        var langMatch = langReg.firstMatch(src.substring(start, end));
            int langStart = start + langMatch.start; // 第一个"`"的位置
int langEnd = start + langMatch.end; // "dart"行的"\n"位置
            String language = src.substring(langStart + 3, langEnd).trim();
          ```
```dart
// 另一个代码块
void main() => print("Hello world");
```

```dart
```dart
// 容错测试(经不起折腾, 请按照正规语法办事)
void main() => print("Hello world");
```
```

`代码段`
  `缩进的代码段`
`代码段`普通文本`代码段`***加粗倾斜文本******加粗倾斜文本***普通文本*斜体文本*OHHHHHHHHHHHHHHHHHHHHHHHH(折行测试)

---
# yaml
string_1: "Bar"
string_2: 'bar'
string_3: bar
---
      ---
      # 缩进的yaml
      string_1: "Bar"
      string_2: 'bar'
      string_3: bar
      ---
---
# 又一个yaml
string_1: "Bar"
string_2: 'bar'
string_3: bar
---

---         yaml
# 无效的yaml
string_1: "Bar"
string_2: 'bar'
string_3: bar
---yaml

[百度](https://www.baidu.com)普通文字
  ##### **[百度加粗](https://www.baidu.com)**
      [**百度加粗(链接解析失效)**](https://www.baidu.com)
- [链接](https://www.baidu.com)普通文字

右侧图片![图片](http://via.placeholder.com/350x150)

""",
        css: baseCSS,
      ),
    );
  }
}
