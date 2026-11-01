[Guide home](../README.md) · Next: [02 Dart Basics](02-dart-basics.md)

# Start Here

**Goal:** get this note and your code on screen side by side, then run one thing.

You need [Flutter](https://docs.flutter.dev/get-started/install) and [VS Code](https://code.visualstudio.com). These notes were tested with Flutter 3.47.9 and Dart 3.13.7, and the practice project needs Dart 3.13.7 or newer.

## Set up your screen

1. Open a terminal and run this:

```powershell
git clone https://github.com/Gaurav-py-Ghosh/Dart-and-Flutter-101.git
cd Dart-and-Flutter-101/flutter_interview_lab
flutter pub get
code .
```

2. Put this note and VS Code side by side. On Windows, `Win + Left` and `Win + Right` snap a window to each side of the screen.
3. In VS Code, press ``Ctrl + ` `` to open the terminal.

## Check that everything runs

Run these one at a time in the VS Code terminal:

```powershell
dart run bin/d01_basics.dart
flutter test
flutter run -d windows
```

| Command | What you should see |
|---|---|
| `dart run bin/d01_basics.dart` | The lesson prints its results |
| `flutter test` | `All tests passed!` |
| `flutter run -d windows` | A window with a list of 14 labs |

> [!WARNING]
> **Use Windows for the app**
>
> Use `-d windows`, not Chrome. The Performance lab only shows its full lesson on Windows, because the web has no separate background workers.

**On macOS or Linux:** the project includes Windows, Android and web only. Run `flutter create --platforms=macos .` or `flutter create --platforms=linux .` once in the project folder, then use `-d macos` or `-d linux` wherever the notes say `-d windows`. This path hasn't been tested.

While the app runs, use these keys in the terminal:

| Key | What it does |
|---|---|
| `r` | **Hot reload:** puts your code change in the running app and keeps its state |
| `R` | **Hot restart:** restarts the app from the beginning and clears its state |
| `q` | Quit |

## Your first hot reload

1. Open `lib/main.dart`.
2. Change `'Flutter Interview Lab'` in the `AppBar` title to your own name.
3. Save, then press `r` in the terminal. The title changes straight away.

## What's in the project

| Folder | What's inside | How to run it |
|---|---|---|
| `bin/` | 3 Dart lessons, with no app needed | `dart run bin/d01_basics.dart` |
| `lib/labs/` | The screens behind the 14 labs | `flutter run -d windows` |
| `lib/architecture/` | A small complete app, built the recommended way | Lab 9 in the app |
| `test/` | Working example tests | `flutter test` |
| `integration_test/` | Tests that drive the real app | `flutter test integration_test -d windows` |
| `lib/challenges/` | Coding problems for you to solve | `flutter test challenge_test` |
| `lib/solutions/` | Answers to those problems | Read after you've tried |

**Three ways to practise**

| What | Where | How to run it |
|---|---|---|
| **Code-alongs:** small programs you type yourself | `bin/my_*.dart`, which you create | `dart run bin/my_bill.dart` |
| **My Tasks:** one real app you build across notes 06 to 14 | `lib/my_app/main.dart`, which you create | `flutter run -d windows -t lib/my_app/main.dart` |
| **Workbooks:** problems that tests check for you | `lib/workbook/w02.dart`, and so on | `flutter test workbook_test/w02_test.dart` |

Answers are in `lib/workbook_answers/`. Every stage of My Tasks is there too, in `lib/workbook_answers/tasks_app/`.

## How to study each note

Each note follows the same order:

1. **Learn:** read the idea, with its examples.
2. **Code along:** **type** the code yourself. Don't paste it. In a live round, nobody hands you code, so your fingers need the practice.
3. **Workbook:** solve problems by yourself, and let the tests check you.
4. **Break it:** cause errors on purpose, so you recognise them later.
5. **Test yourself:** say each answer **out loud**, then click to reveal it. Interviews are spoken.

**When a test fails, read what it says:**

```text
Expected: <6>
  Actual: <0>
```

Your code gave `0`, but it should give `6`. `UnimplementedError` just means you haven't written that one yet.

**If you're stuck for 5 minutes:** look at the answer, understand it, close it, and write it again from memory.

Move on from a note when you can explain it without looking.

## Done when

- [ ] Note and VS Code are side by side
- [ ] `flutter test` shows `All tests passed!`
- [ ] The lab window opens
- [ ] You've done one hot reload

Next: [02 Dart Basics](02-dart-basics.md)
