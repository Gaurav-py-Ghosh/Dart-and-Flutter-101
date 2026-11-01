[Guide home](../README.md) · Back: [05 How Flutter Works](05-how-flutter-works.md) · Next: [07 Lifecycle and Keys](07-lifecycle-and-keys.md)

# Layout and Widgets

**Why this matters:** you'll build screens in any practical round, and most layout bugs come from one rule.

**See it working:** `flutter run -d windows`, then open lab 1. The code's in `lib/labs/ui_labs.dart`.

**New from this note on:** you'll build a real app called **My Tasks**, adding to it in each note. By note 14 you'll have a tested app with a real API, built by you. That's something to talk about in your interview.

---

# Part 1: Learn

## 1. The one rule

> **Constraints go down. Sizes go up. The parent sets the position.**

Think of a parent speaking to a child:

1. **Parent:** "You can be between 0 and 300 wide."
2. **Child:** "OK, I'll be 100."
3. **Parent:** "Then I'll put you here."

A **constraint** is a minimum and maximum width and height. A child **can't choose a size its parent doesn't allow.** That's why this box is 100 wide, not 500:

```dart
ConstrainedBox(
  constraints: const BoxConstraints.tightFor(width: 100, height: 50),
  child: Container(width: 500, color: Colors.purple), // ends up 100 wide
)
```

**Tight vs loose:**

| Kind | Meaning | Example |
|---|---|---|
| **Tight** | Min and max are equal: "be exactly this size" | The screen forces its first child to fill it |
| **Loose** | Min is 0: "be up to this size" | `Center` lets its child be smaller |
| **Unbounded** | Max is infinite: "as big as you like" | `Column` gives this to children, for height |

That's why a bare `Container` at the top of an app fills the whole screen, but inside a `Center` it shrinks.

## 2. The basic building blocks

**Text:**

```dart
const Text(
  'Big bold title',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  maxLines: 1,
  overflow: TextOverflow.ellipsis, // shows ... if too long
)
Text('Theme text', style: Theme.of(context).textTheme.titleLarge)
```

**Icons and images:**

```dart
const Icon(Icons.star, color: Colors.amber, size: 32)
Image.network('https://example.com/a.png', cacheWidth: 200)
Image.asset('assets/photo.png', width: 100, fit: BoxFit.cover)
```

To use your own image, put it in a folder such as `assets/`, then declare it in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/photo.png
```

**Container: the all-in-one box**

```dart
Container(
  width: 200,
  height: 80,
  margin: const EdgeInsets.all(8),      // space outside
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // space inside
  alignment: Alignment.center,
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.black),
  ),
  child: const Text('Styled box'),
)
```

If you use `decoration`, put the color **inside** it. Setting both `color` and `decoration` is an error.

**Container vs SizedBox:** `SizedBox` only sets a size, and it can be `const`, so it's lighter. Use it for gaps: `const SizedBox(height: 12)`.

**Buttons:**

| Widget | Look |
|---|---|
| `FilledButton` | Solid. Main action |
| `ElevatedButton` | Raised |
| `OutlinedButton` | Border only |
| `TextButton` | Text only |
| `IconButton` | Just an icon |
| `FloatingActionButton` | Round, floating. Used in `Scaffold` |

Setting `onPressed: null` disables a button.

**Tapping anything:** wrap it in `GestureDetector` (no visual feedback) or `InkWell` (with a ripple).

```dart
GestureDetector(onTap: () => print('Tapped'), child: const Text('Tap anything'))
```

**Handy widgets:** `Center`, `Align`, `Padding`, `Card`, `Divider`, `SafeArea`, `Spacer`.

**ListTile** is a ready-made row, with spaces for everything:

```dart
const ListTile(
  leading: Icon(Icons.person),
  title: Text('Asha'),
  subtitle: Text('Developer'),
  trailing: Icon(Icons.chevron_right),
)
```

## 3. The page: Scaffold

`Scaffold` is the basic page structure:

```dart
Scaffold(
  appBar: AppBar(title: const Text('Title')),
  body: const Text('Main content'),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: const Icon(Icons.add),
  ),
  drawer: const Drawer(),
  bottomNavigationBar: NavigationBar(destinations: const [...]),
)
```

**Showing a message at the bottom:**

```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Saved')),
);
```

## 4. Row and Column

`Row` goes across, and `Column` goes down.

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.center,
  spacing: 8,
  children: [ ... ],
)
```

| Property | Meaning | For a Row | For a Column |
|---|---|---|---|
| `mainAxisAlignment` | Along the direction of travel | Left to right | Top to bottom |
| `crossAxisAlignment` | Across it | Top to bottom | Left to right |
| `mainAxisSize` | Fill the space, or shrink to fit | `max` or `min` | `max` or `min` |
| `spacing` | The gap between children | | |

**How a Row works out sizes:**

1. It gives non-flexible children as much width as they want.
2. It shares what's left between the `Expanded` and `Flexible` children.
3. If non-flexible children are too wide, you get the **overflow error**.

## 5. Expanded and Flexible

```dart
Row(
  children: [
    Container(width: 60, height: 50, color: Colors.red),   // fixed
    Expanded(flex: 2, child: Container(height: 50, color: Colors.green)),
    Expanded(child: Container(height: 50, color: Colors.blue)),
  ],
)
```

After the red box takes 60, green gets 2 shares of what's left, and blue gets 1.

| Widget | Behaviour |
|---|---|
| `Expanded` | **Must** fill its share |
| `Flexible` | **May** be smaller |
| `Spacer` | An empty `Expanded`, for pushing things apart |

They only work **directly** inside a `Row`, `Column` or `Flex`.

**Long text in a Row** is the classic overflow. Wrap the text in `Expanded`, so it knows how much room it has:

```dart
Row(
  children: [
    Expanded(child: Text(label)),
    Text('Rs $price'),
  ],
)
```

## 6. Stack: layers

```dart
Stack(
  children: [
    Container(color: Colors.amber),
    const Positioned(right: 8, bottom: 8, child: Icon(Icons.star)),
  ],
)
```

Children are drawn in order, so the last is on top. `Positioned` must be a direct child of a `Stack`.

## 7. Wrap

Like a `Row`, but it flows onto a new line rather than overflowing. It's perfect for tags.

## 8. Scrolling

**A column that's too long overflows.** Make it scroll with `SingleChildScrollView`. It's fine for a form, but it builds everything, so don't use it for long lists.

**Lists: always think "lazy".**

| | `ListView(children: [...])` | `ListView.builder` |
|---|---|---|
| Builds | Every item, right away | Only what's near the screen |
| Use for | A few items | Long or unknown length |

```dart
ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) => ListTile(title: Text(todos[index].title)),
)
```

`itemBuilder` is called only for items about to appear. With a list of 1,000 items, only a handful get built.

**Others:** `ListView.separated` adds dividers, and `GridView.builder` makes a grid:

```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  itemCount: 100,
  itemBuilder: (context, index) => Text('Cell $index'),
)
```

**Slivers** are pieces of a scrollable area. Use them for effects such as a collapsing header above a list:

```dart
CustomScrollView(
  slivers: [
    const SliverAppBar(pinned: true, expandedHeight: 160),
    SliverList.builder(
      itemCount: 100,
      itemBuilder: (context, index) => ListTile(title: Text('Row $index')),
    ),
  ],
)
```

**What about `shrinkWrap`?** Setting `shrinkWrap: true` makes a list only as tall as its items, so it can sit inside a `Column`. The cost is that it must **measure every item**, which throws away the laziness you wanted. It's fine for a handful of items. For a long list, wrap it in `Expanded`, or use slivers.

## 9. Screens of every size

| Tool | Use it to |
|---|---|
| `LayoutBuilder` | Change layout, based on space **from the parent** |
| `MediaQuery.sizeOf(context)` | Read the **whole screen** size |
| `SafeArea` | Avoid notches and system bars |
| `Expanded`, `Wrap` | Flow naturally |

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final isWide = constraints.maxWidth > 600;
    return isWide ? const WideLayout() : const NarrowLayout();
  },
)
```

## 10. Errors you must recognise

| Error | Cause | Fix |
|---|---|---|
| `A RenderFlex overflowed by X pixels` | A Row or Column's children don't fit | Use `Expanded`, `Flexible`, `Wrap`, or scrolling |
| `Vertical viewport was given unbounded height` | `ListView` inside a `Column`: "be as tall as you want" meets "I want everything" | Wrap the list in `Expanded` |
| `Incorrect use of ParentDataWidget` | `Expanded` or `Positioned` under the wrong parent | Put `Expanded` directly in a Row or Column, and `Positioned` directly in a Stack |
| `No Material widget found` | A Material widget has no Material ancestor | Put it inside a `Scaffold` or `Material` |
| `BoxConstraints forces an infinite width` | A child wants infinite width in an unbounded space | Give it a size, or use `Expanded` |

---

# Part 2: Code along: My Tasks, stage 1

**Goal:** a screen that shows a list of tasks. No tapping yet.

**Step 1.** Create a new file, `lib/my_app/main.dart`. You'll keep adding to this one file.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyTasksApp());

class MyTasksApp extends StatelessWidget {
  const MyTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Tasks',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: Scaffold(
        appBar: AppBar(title: const Text('My Tasks')),
        body: const Text('Tasks go here'),
      ),
    );
  }
}
```

Run it, and **leave it running**:

```powershell
flutter run -d windows -t lib/my_app/main.dart
```

**Step 2: The model.** Add this at the bottom. It's plain Dart, with no widgets, as you learned in [03 Dart Classes and Modern Features](03-dart-classes-and-modern-features.md).

```dart
class Task {
  const Task({required this.id, required this.title, this.done = false});

  final int id;
  final String title;
  final bool done;
}

const sampleTasks = [
  Task(id: 1, title: 'Learn widgets', done: true),
  Task(id: 2, title: 'Build a layout'),
  Task(id: 3, title: 'Pass the interview'),
];
```

**Step 3: One row.** Add this widget:

```dart
class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(task.done ? Icons.check_circle : Icons.circle_outlined),
          const SizedBox(width: 12),
          Expanded(child: Text(task.title)),
          Text(task.done ? 'Done' : 'To do'),
        ],
      ),
    );
  }
}
```

Why `Expanded`? It pushes the status to the far right, and stops a long title from overflowing.

**Step 4: The screen.** A widget gets its data through its constructor.

```dart
class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) => TaskTile(task: tasks[index]),
      ),
    );
  }
}
```

**Step 5.** In `MyTasksApp`, replace the `home: Scaffold(...)` with:

```dart
home: const TasksScreen(tasks: sampleTasks),
```

Save, and press `r`. You should see 3 rows, each with an icon, a title and a status.

**Stuck?** Compare with `lib/workbook_answers/tasks_app/stage06.dart`. You can run that file as well, using `-t`.

**Now change it yourself:**

- [ ] Add 30 more sample tasks. Scroll. Nothing overflows, as it's a list.
- [ ] Make one title very long. See it wrap, thanks to `Expanded`.
- [ ] Put each row inside a `Card`.
- [ ] Show the title with a strikethrough if it's done: `TextStyle(decoration: TextDecoration.lineThrough)`.
- [ ] Add a `Divider` between rows, using `ListView.separated`.

---

# Part 3: Workbook

**Open:** `lib/workbook/w06.dart`

**Check:** `flutter test workbook_test/w06_test.dart`

To replace a placeholder:

```dart
// Before
Widget build(BuildContext context) => throw UnimplementedError();

// After
Widget build(BuildContext context) {
  return Card(...);
}
```

- [ ] 1 `ProfileCard`: `Card`, `Row`, `Column`
- [ ] 2 `PriceRow`: `Expanded`. The test also tries a very long label
- [ ] 3 `NameList`: `ListView.builder`. The test checks it's really lazy
- [ ] 4 `BadgeIcon`: `Stack` and `Positioned`
- [ ] 5 `ResponsiveLabel`: `LayoutBuilder`
- [ ] 6 `ChatScreen`: the `ListView` in a `Column` fix

---

# Part 4: Break it on purpose

Edit `LayoutLab` in `lib/labs/ui_labs.dart`, and press `r` after each change:

- [ ] Change `Wrap(` to `Row(`. Yellow and black overflow stripes appear. Read the error in the terminal.
- [ ] Change `flex: 2` to `flex: 5`. The green section grows.
- [ ] Change the purple box's parent `width: 100` to `200`. It's now 200 wide, still not 500.
- [ ] Resize the window narrower than 600. The last box changes from teal to orange.
- [ ] In your My Tasks app, wrap the `ListView.builder` in a `Column`. Read the `unbounded height` error, then fix it using `Expanded`.

---

# Part 5: Test yourself

<details>
<summary>How does layout work in Flutter?</summary>

Constraints go down, sizes go up, and the parent sets the position. A parent tells its child the minimum and maximum size allowed. The child picks a size within those limits, and tells the parent, which then places it. It's a single pass, so it's fast.

</details>

<details>
<summary>What are tight and loose constraints?</summary>

Tight means the minimum and maximum are equal, so the child must be exactly that size. Loose means the minimum is 0, so the child can be anything up to the maximum.

</details>

<details>
<summary><code>Expanded</code> vs <code>Flexible</code>?</summary>

Both share free space inside a Row or Column. `Expanded` forces the child to fill its share. `Flexible` lets the child be smaller. In fact, `Expanded` is a `Flexible` with a tight fit.

</details>

<details>
<summary><code>Container</code> vs <code>SizedBox</code>?</summary>

`SizedBox` only sets a size, and it can be `const`, so it's lighter. `Container` also combines padding, color, decoration and more. Use `SizedBox` when all you need is a size or gap.

</details>

<details>
<summary><code>mainAxisAlignment</code> vs <code>crossAxisAlignment</code>?</summary>

Main is along the direction of the Row or Column. Cross is perpendicular to it. For a Row, main is horizontal and cross is vertical.

</details>

<details>
<summary>Why does a ListView in a Column crash?</summary>

A Column gives its children unlimited height, and a ListView tries to fill all the height it's given. Infinite height can't be drawn. The fix is to wrap the ListView in `Expanded`, which gives it a real limit.

</details>

<details>
<summary>Is <code>shrinkWrap: true</code> a good fix for that?</summary>

It works, but it gives up lazy building, because the list has to measure all its items. That's bad for long lists, so `Expanded` is usually better.

</details>

<details>
<summary><code>ListView</code> vs <code>ListView.builder</code>?</summary>

The plain constructor builds all children right away. The builder only creates what's near the visible area, so it's the right choice for long lists.

</details>

<details>
<summary>What is a sliver?</summary>

A piece of a scrollable area that lays itself out based on the scroll position. Use `CustomScrollView` with slivers for effects like a collapsing header, or to combine different scrolling parts lazily.

</details>

<details>
<summary><code>LayoutBuilder</code> vs <code>MediaQuery</code>?</summary>

`MediaQuery` gives you the whole screen's information. `LayoutBuilder` gives you the space your parent is actually offering. For reusable widgets, `LayoutBuilder` is usually better, because the widget may not be full-screen.

</details>

<details>
<summary>How do you build for both phones and tablets?</summary>

I pick layouts based on width using `LayoutBuilder` or `MediaQuery.sizeOf`, with breakpoints such as 600. I use flexible widgets like `Expanded` and `Wrap` rather than fixed sizes, use a navigation rail instead of a bottom bar on wide screens, and test on several sizes.

</details>

<details>
<summary>How do you add an image to your app?</summary>

Put the file in a folder like `assets/`, declare it under `flutter: assets:` in `pubspec.yaml`, and show it using `Image.asset`. For images from the internet, use `Image.network`.

</details>

# Done when

- [ ] You can say the one rule, and explain it with an example
- [ ] You saw an overflow and can explain the fix
- [ ] My Tasks shows a list, built by you
- [ ] At least 5 of 6 workbook tests pass

Next: [07 Lifecycle and Keys](07-lifecycle-and-keys.md)
