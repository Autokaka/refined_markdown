import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refined_markdown/refined_markdown.dart';

void main() {
  testWidgets(
    "Violent Widget Test",
    (WidgetTester tester) async {
      var markdownKey = UniqueKey();

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            CSS baseCSS = CSS();
            return MaterialApp(
              home: Scaffold(
                body: RefinedMarkdown(
                  key: markdownKey,
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
***仅加粗**
**仅加粗***
***仅倾斜*
*仅倾斜**
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
`代码段`普通文本`代码段`***加粗倾斜文本***普通文字***加粗倾斜文本***普通文本*斜体文本*OHHHHHHHHHHHHHHHHHHHHHHHH(折行测试)


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


分割线
----
不解析的分割线 ----
----不解析的分割线


~~删除线~~普通文字~~删除线~~普通文字**加粗文字***斜体****加粗斜体***==文字高亮==
  ====不解析高亮

<font color=red size=20>红色文字, 大小20</font>
<font color=red size=11>红色文字, 大小11</font>普通文字<font color=red size=20>红色文字, 大小5</font>**加粗文字**
<font color=red size=11>红色文字, 大小11</font>普通文字**加粗文字***倾斜文字**倾斜文字*普通文字~~删除线~~==语法高亮==<br/><font color=red size=20>红色文字, 大小5</font>
换行符<br/>换行符
""",
                  css: baseCSS,
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
