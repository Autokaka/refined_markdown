## 1.2.0

### Add

1. Minimal text style support using html grammar.
2. New picture rendering (**online picture only! I will not support using local pictures because this might be quite complex and involves quite a lot of native adaptations**)
3. Deleted text rendering
4. Highlighted text rendering
5. Divider rendering

### Fix

1. Link rendering fault when mixed with normal text

### Optimize

1. Bold text and etalic text displaying

### Notice

1. This is the very stable version that has lived up to my expectation right now, if there are any rendering fault, feel free to give an Issue or a PR, that will help a lot.
2. I’m working on rendering tables, this might be a hard process, I need more time.
3. Due to my laziness, if you have any ideas about how to render local pictures, feel free to contact me, thank you very much!

## 1.1.0

### Optimize

All rendering logic, now the rendering order no longer relies on the so-called “priorities”.

### Fix

1. “\n” rendering when input contains "\n\n”
2. Link rendering failed when bold text format “\*\*” is in “[]”
3. Bold and italic rendering fault when enrolled in normal words
4. Code segment rendering fault when it is empty
5. More minor bug fixes.

## 1.0.0+6

[Add] Basic travis CI support.

## 1.0.0+5

Upload version badge in README for convenience. =w=

## 1.0.0+4

### Fix

1. Symbol displaying of normal list
2. “\n” ignored in links at the beginningof a new line
3. Links failed to render when a list is formerly declared

### Optimize

1. All lists rendering logic
2. All links rendering logic

### Notice

If there are still displaying problems, please feel free to give an Issue or a PR, I’ll handle them as quickly as I can, thank you.

## 1.0.0+3

You know what, the displaying of readme looks weird. QAQ

## 1.0.0+2

Really sorry, update README again! I am an obsessive. QAQ

## 1.0.0

Nothing changed, just update README, and prove that this package is not an early version.

## 0.0.1

First commit.

### What is working now?

Now support rendering the following grammar. Some of them may not work as you wish, I am trying my best to optimize it, please be patient.

- Normal text

- Bold text

- Italic text

- Syntax highlight

- code segment

- Code blocks(including highlighting, using flutter_highlight. Thanks to pd4d10!)
  
- ##### headers

- Normal list

- Links

- Pictures

- Sequence list

- Task list

### What is next?

1. Just optimize the functions that has been built as much as I can.
2. Add some html support that are frequently used.
3. Support table rendering.
