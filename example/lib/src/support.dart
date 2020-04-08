import 'dart:io';
import 'package:flutter/material.dart';

import './css.dart';
import './renderer.dart';

/// 解析支持表, 支持渐进式开发. 当需要渲染新的Markdown标记时, 只需要实现基于Renderer的渲染类即可
/// 需要注意的是, Markdown语法有着较为严格的"优先级", 所以本表的顺序也是渲染顺序, 如果您不了解
/// Markdown的渲染顺序, 请查阅资料或自行测试后再在适当位置添加额外渲染支持
final Map<String, dynamic> supports = {
  // YAML
  r"\n *-{3} *\n[\s\S]*?\n *-{3} *":
      (String src, int start, int end, CSS css, BuildContext context) =>
          YAMLDoc(src: src, start: start, end: end, css: css).build(context),
  // 代码块
  r"\n *`{3}.*\n[\s\S]*?\n *`{3}[^\n]*":
      (String src, int start, int end, CSS css, BuildContext context) =>
          CodeBlock(src: src, start: start, end: end, css: css).build(context),
  // 代码段
  r"`[^ `\n]+`": (String src, int start, int end, CSS css,
          BuildContext context) =>
      CodeSegment(src: src, start: start, end: end, css: css).build(context),
  // 任务列表
  r"\n *- \[(x| )\] [^\n]+":
      (String src, int start, int end, CSS css, BuildContext context) =>
          TaskList(src: src, start: start, end: end, css: css).build(context),
  // 常规列表
  r"\n *- [^\n]+":
      (String src, int start, int end, CSS css, BuildContext context) =>
          NormalList(src: src, start: start, end: end, css: css).build(context),
  // 顺序列表
  r"\n *\d+\. [^\n]+":
      (String src, int start, int end, CSS css, BuildContext context) =>
          SeqList(src: src, start: start, end: end, css: css).build(context),
  // 标题
  r"\n *###### [^\n]+":
      (String src, int start, int end, CSS css, BuildContext context) =>
          Header(src: src, start: start, end: end, css: css, size: 0)
              .build(context),
  r"\n *##### [^\n]+":
      (String src, int start, int end, CSS css, BuildContext context) =>
          Header(src: src, start: start, end: end, css: css, size: 5)
              .build(context),
  r"\n *#### [^\n]+":
      (String src, int start, int end, CSS css, BuildContext context) =>
          Header(src: src, start: start, end: end, css: css, size: 10)
              .build(context),
  r"\n *### [^\n]+":
      (String src, int start, int end, CSS css, BuildContext context) =>
          Header(src: src, start: start, end: end, css: css, size: 15)
              .build(context),
  r"\n *## [^\n]+":
      (String src, int start, int end, CSS css, BuildContext context) =>
          Header(src: src, start: start, end: end, css: css, size: 20)
              .build(context),
  r"\n *# [^\n]+":
      (String src, int start, int end, CSS css, BuildContext context) =>
          Header(src: src, start: start, end: end, css: css, size: 25)
              .build(context),
  // 粗体
  r"\*{2,}[^\n\*]+\*{2,}":
      (String src, int start, int end, CSS css, BuildContext context) =>
          BoldText(src: src, start: start, end: end, css: css).build(context),
  // 斜体
  r"\*[^\n\*]+\*":
      (String src, int start, int end, CSS css, BuildContext context) =>
          ItalicText(src: src, start: start, end: end, css: css).build(context),
  // 图片
  r"!\[[^\n]*\]\([^\n]*\)":
      (String src, int start, int end, CSS css, BuildContext context) =>
          MDImage(src: src, start: start, end: end, css: css).build(context),
  // 链接
  r"\[.+\]\(.+\)":
      (String src, int start, int end, CSS css, BuildContext context) =>
          Link(src: src, start: start, end: end, css: css).build(context),
};
