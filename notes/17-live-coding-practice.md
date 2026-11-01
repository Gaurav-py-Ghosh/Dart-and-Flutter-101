[Guide home](../README.md) · Back: [16 Whats New in 2026](16-whats-new-in-2026.md) · Next: [18 Mock Interview Questions](18-mock-interview-questions.md)

# Live Coding Practice

**Why this matters:** reading isn't enough. This is where you find out what you actually know.

**Your work:** `lib/challenges/challenges.dart`
**Check it:** `flutter test challenge_test`
**Answers:** `lib/solutions/solutions.dart`

All 11 checks start out failing. Your job is to make them pass.

To run one challenge at a time:

```powershell
flutter test challenge_test --plain-name "1 isPalindrome"
```

## How to behave in a live round

Interviewers are judging how you think, as well as your code.

1. **Repeat the problem** in your own words.
2. **Ask questions.** "Are there empty inputs? Should it ignore case?"
3. **Say your plan** before you type.
4. **Think out loud** as you code.
5. **Start simple**, then improve it.
6. **Test with an example**, including an edge case.
7. **Mention the cost**, such as "This is O(n), since I go through the list once."

If you get stuck, say what you're stuck on. Silence is what hurts.

## Part 1: Dart logic

Give each one 10 minutes before you look at the answer.

| # | Challenge | Hint |
|---|---|---|
| 1 | `isPalindrome` | Clean the text, then compare from both ends |
| 2 | `wordCount` | A Map from word to count |
| 3 | `uniqueInOrder` | Dart Sets keep insertion order |
| 4 | `twoSum` | A Map of values you've already seen makes it O(n) |
| 5 | `flatten` | Recursion, or collection `for` and `if` |
| 6 | `groupBy` | `putIfAbsent` |
| 7 | `retry` | A loop with `try`, `catch` and `rethrow` |
| 8 | `Debouncer` | Cancel the old `Timer` on each call |
| 9 | `Stack` | Wrap a List |
| 10 | `LruCache` | Dart Maps keep insertion order. Remove and re-add to mark as recent |

- [ ] 1 isPalindrome
- [ ] 2 wordCount
- [ ] 3 uniqueInOrder
- [ ] 4 twoSum
- [ ] 5 flatten
- [ ] 6 groupBy
- [ ] 7 retry
- [ ] 8 Debouncer
- [ ] 9 Stack
- [ ] 10 LruCache

**Short on time?** Do 1, 3, 7 and 8. Numbers 7 and 8 are the most Flutter-relevant.

## Part 2: Build these screens

**You've already built most of this in My Tasks.** Now do it again from a blank file, without looking. That's the real test. Create each one as `lib/my_app/task_a.dart` and so on, and run it using `-t`.

These are the most common practical tasks. **Create a new file for each one and close the lab code**, then compare with the lab afterward.

### Task A: Counter (5 minutes)

A number, and + and - buttons. It can't go below 0.
**Compare with:** `SetStateCounter` in `state_labs.dart`.

- [ ] Done

### Task B: Login form (15 minutes)

Email and password fields, with validation. Show a spinner for 2 seconds on submit, and then a welcome message.
**Compare with:** `FormLab` in `ui_labs.dart`.
**Remember:** `GlobalKey<FormState>`, `dispose`, and checking `mounted` after the wait.

- [ ] Done

### Task C: API list screen (25 minutes)

**This is the big one.** Fetch a list and display it, with loading, error, and retry. Use this free test API:

`https://jsonplaceholder.typicode.com/todos`

**Compare with:** `lib/architecture/todo_architecture.dart`.
**Remember:** model with `fromJson`, repository, ViewModel, sealed state, `ListView.builder`.

- [ ] Done

### Task D: Search with debounce and infinite scroll (20 minutes)

A search box that waits until typing stops, and a list that loads more near the bottom.
**Compare with:** `SearchLab` in `app_labs.dart`.

- [ ] Done

### Task E: Todo list with add, toggle, delete (20 minutes)

**Compare with:** `TodoViewModel`.
**Remember:** `ValueKey`, immutable updates using `copyWith`.

- [ ] Done

## Part 3: Predict the output

Say the answer out loud, then reveal it. To check one, paste it into [DartPad](https://dartpad.dev) inside `void main() async { }`, with `import 'dart:async';` at the top.

<details>
<summary><code>final a = [1]; a.add(2); print(a);</code></summary>

`[1, 2]`. `final` protects the variable, not the contents.

</details>

<details>
<summary><code>const a = [1]; a.add(2);</code></summary>

It crashes at runtime: `Unsupported operation: Cannot add to an unmodifiable list`.

</details>

<details>
<summary><code>print(identical(const [1], const [1]));</code> and then without <code>const</code></summary>

`true`, and then `false`. Identical const values are a single shared object.

</details>

<details>
<summary><code>print({1, 2, 2, 3}.length);</code></summary>

`3`. A Set removes duplicates.

</details>

<details>
<summary><code>class Both with A, B {}</code>, where both define <code>who()</code>. What does <code>Both().who()</code> return?</summary>

`B`. The last mixin wins.

</details>

<details>
<summary>Order: <code>print(1); Future(() =&gt; print(2)); scheduleMicrotask(() =&gt; print(3)); print(4);</code></summary>

`1, 4, 3, 2`. Normal code first, then microtasks, then events.

</details>

<details>
<summary><code>String? s; print(s?.length ?? 'none');</code></summary>

`none`. `?.` gives null, and `??` gives the fallback.

</details>

<details>
<summary><code>numbers.map((n) { print(n); return n; });</code> on its own. What prints?</summary>

Nothing. `map` is lazy, and nothing reads the result.

</details>

<details>
<summary>A timeout test: <code>await Future.delayed(Duration(seconds: 2)).timeout(Duration(seconds: 1));</code></summary>

It throws a `TimeoutException` after 1 second.

</details>

## Done when

- [ ] At least four of the Dart challenges pass, without looking
- [ ] You built Task C without looking
- [ ] You explained your thinking out loud as you worked

Next: [18 Mock Interview Questions](18-mock-interview-questions.md)
