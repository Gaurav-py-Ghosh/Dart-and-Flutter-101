[Guide home](../README.md) · Back: [19 Your Story](19-your-story.md)

# Interview Day Cheat Sheet

**Read this on the morning of your interview, and then stop studying.** Don't learn anything new that day.

## The 12 answers that matter most

| # | Topic | One line to remember |
|---|---|---|
| 1 | **final vs const** | `final` is set while running. `const` is known in advance and frozen |
| 2 | **Null safety** | Not null unless you add `?`. Avoid `!` |
| 3 | **extends / implements / with** | Inherit code / sign a contract / add skills |
| 4 | **Event loop** | Normal code, then microtasks, then events |
| 5 | **async vs isolate** | Waiting vs heavy calculation |
| 6 | **Three trees** | Widget is the blueprint, Element is the manager, RenderObject is the house |
| 7 | **Layout** | Constraints down, sizes up, parent sets position |
| 8 | **Lifecycle** | createState, initState, didChangeDependencies, build, didUpdateWidget, deactivate, dispose |
| 9 | **Keys** | Name tags, so state stays with its item when reordering |
| 10 | **State management** | `setState` for local. Provider, Riverpod or Bloc for shared. It depends on the app and team |
| 11 | **Architecture** | View, ViewModel, Repository, Service. One-way data flow, with DI |
| 12 | **Jank** | Profile mode, on a real device. Measure, fix, measure again |

## Numbers

| What | Number |
|---|---|
| Frame budget at 60 Hz | 16 ms |
| Frame budget at 120 Hz | About 8 ms |
| Current Flutter | 3.47.9 |
| Current Dart | 3.13.7 |
| Minimum tap target | 48 by 48 |

## Quick pairs

| Pair | Difference |
|---|---|
| `var` / `dynamic` / `Object?` | Type worked out, then fixed / no checks, so it crashes at runtime / holds anything, but check with `is` first |
| `is` / `as` | Safely asks the type / forces it, and crashes if wrong |
| Compile time / runtime | Caught before running / crashes in front of a user |
| Future / Stream | One value / many values |
| Stateless / Stateful | No own data / has a State object |
| Hot reload / restart | Keeps state / loses state |
| Expanded / Flexible | Must fill / may fill |
| ChangeNotifier / ValueNotifier | Many values, with methods / one value |
| `watch` / `read` | Rebuilds / doesn't |
| Bloc / Cubit | Events / methods |
| BlocBuilder / BlocListener | Draw UI / one-time action |
| Fake / mock | Working stand-in / checks calls |
| `pump` / `pumpAndSettle` | One frame / until finished |
| Implicit / explicit animation | Automatic / you control it |
| Package / plugin | Dart only / with native code |
| JIT / AOT | Compiled while running / in advance |
| `push` / `go` | Adds a page / changes location |
| shared_preferences / secure storage | Settings / secrets |

## Rules for clean code

1. Dispose what you create.
2. Check `mounted` after `await`.
3. Never start work in `build`.
4. No logic in widgets.
5. `ListView.builder` for long lists.
6. `const` wherever possible.
7. Handle loading, data, empty and error.

## New in 2026

- `material_ui` and `cupertino_ui` are splitting out of the framework.
- Primary constructors: `class Point(final int x, final int y);`
- Impeller is the default on desktop too.
- Widget Previews are stable.

## Your opening line

Go to [19 Your Story](19-your-story.md), and read your introduction out loud twice.

## Morning checklist

**Before you start:**

- [ ] Eat something, and drink water
- [ ] Read this page once, and your story once
- [ ] Run `flutter doctor`, and make sure `flutter create` works, in case of a live round
- [ ] VS Code open, with a blank project, and notifications off
- [ ] Laptop charged, internet and microphone tested
- [ ] Job description open, and your questions for them ready

**During the interview:**

- [ ] Pause before you answer. It's fine to take a few seconds
- [ ] Short answer first, then an example
- [ ] Think out loud during coding
- [ ] If you don't know, say so, then reason it through
- [ ] Ask your questions at the end

> [!TIP]
> **One last thing**
>
> You ran this code, broke it and fixed it. You aren't reciting theory. You've seen it work. Speak from that.
