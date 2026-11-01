[Guide home](../README.md) · Back: [17 Live Coding Practice](17-live-coding-practice.md) · Next: [19 Your Story](19-your-story.md)

# Mock Interview Questions

**How to use this:** set a timer, and **answer out loud** in about 30 to 60 seconds, as if someone were listening. Better still, record yourself. Then click to compare. If you miss one, tick it, and go back to its note.

This note focuses on rapid-fire and scenario questions. Each topic note has more under "Test yourself".

## Round 1: Rapid fire (15 minutes)

<details>
<summary>What is Flutter?</summary>

Google's open-source UI toolkit for building apps for mobile, web and desktop from one codebase, using Dart. It draws its own UI with its own engine, rather than using platform widgets.

</details>

<details>
<summary>Why Dart for Flutter?</summary>

It has JIT compilation for fast hot reload in development, and AOT compilation for fast native performance in release. It also has sound null safety, and an efficient garbage collector that suits creating lots of short-lived widgets.

</details>

<details>
<summary>Everything is a widget. What does that mean?</summary>

UI is built by composing small, immutable descriptions. Even padding and alignment are widgets, rather than properties on a view.

</details>

<details>
<summary><code>StatelessWidget</code> vs <code>StatefulWidget</code>?</summary>

A stateless widget depends only on what's passed to it. A stateful widget has a separate State object that holds data that can change, and `setState` rebuilds it.

</details>

<details>
<summary>What does <code>const</code> do for a widget?</summary>

It makes one shared instance at compile time, so Flutter can skip rebuilding it.

</details>

<details>
<summary>What is <code>BuildContext</code>?</summary>

A widget's location in the tree. It's actually the Element. It's used to look up things like the theme.

</details>

<details>
<summary><code>mainAxisAlignment</code> vs <code>crossAxisAlignment</code>?</summary>

Main is along the direction of the Row or Column. Cross is perpendicular to it.

</details>

<details>
<summary>What is <code>pubspec.yaml</code>?</summary>

The project's config file: name, version, dependencies, assets and fonts.

</details>

<details>
<summary>How do you add an image to your app?</summary>

Put the file in a folder like `assets/`, declare it under `flutter: assets:` in `pubspec.yaml`, and show it using `Image.asset('assets/photo.png')`.

</details>

<details>
<summary>What's a <code>Scaffold</code>?</summary>

The basic page structure: app bar, body, floating button, drawer and bottom bar.

</details>

<details>
<summary>What's <code>SafeArea</code>?</summary>

It adds padding so that content isn't hidden by notches and system bars.

</details>

<details>
<summary>How do you make a network call?</summary>

With `http` or `dio`, inside a repository. Check the status, decode the JSON, and return typed models.

</details>

<details>
<summary>Future vs Stream?</summary>

A Future delivers one value later. A Stream delivers many values over time.

</details>

<details>
<summary><code>async</code> vs isolate?</summary>

Async is for waiting, with one worker switching between jobs. An isolate is a second worker with separate memory, for heavy calculation.

</details>

<details>
<summary>Which state management do you use?</summary>

`setState` for local state. For shared state, it depends on the app and team: Provider for smaller apps, Bloc or Riverpod for larger ones. Then give your real experience.

</details>

<details>
<summary>Hot reload vs hot restart?</summary>

Reload injects code and keeps state. Restart runs the app from the beginning, and loses state.

</details>

<details>
<summary>What are keys?</summary>

Name tags that tell Flutter which widget is which across rebuilds. They're needed when you reorder stateful widgets of the same type.

</details>

<details>
<summary>Debug vs profile vs release?</summary>

Debug has hot reload and checks, using JIT. Profile is near-release speed with performance tools. Release is fully optimised, for users. Profile and release use AOT.

</details>

<details>
<summary>What are mixins?</summary>

Reusable code that you can add to a class using `with`, without inheritance.

</details>

<details>
<summary>What's tree shaking?</summary>

The compiler removes code that's never used, which makes the app smaller.

</details>

## Round 2: Scenarios (15 minutes)

These show real experience. Use this order: **find the cause, then fix it, then prevent it.**

<details>
<summary>A screen makes the same API call many times. Why?</summary>

It's probably being called from `build`, or the Future is created inside a `FutureBuilder`. `build` runs often. I'd move the call to `initState` or a ViewModel, and keep the Future in a field.

</details>

<details>
<summary>A user reports crashes, but you can't reproduce them. What do you do?</summary>

Check Crashlytics or Sentry for the stack trace, device, OS version and app version. Look for a pattern, and add logging around the area. Try to reproduce it using the same OS, a slow network, or low memory. Then fix it, and add a test.

</details>

<details>
<summary>Scrolling is janky on low-end Android.</summary>

Profile on that device. Common causes are large images without `cacheWidth`, non-lazy lists, heavy `build` methods, or expensive effects. Check the UI and raster threads, fix the largest issue, and measure again.

</details>

<details>
<summary>The app's memory keeps growing.</summary>

Use the DevTools Memory view, and compare snapshots while repeating a flow. Look for undisposed controllers, uncancelled subscriptions, or retained large images. Add `dispose` and cancel where they're missing.

</details>

<details>
<summary>The user leaves a screen during a network call, and you get an error.</summary>

The callback ran after the widget was disposed. Check `mounted` before `setState` or using `context`, and keep async work in a ViewModel that cancels it or ignores the result.

</details>

<details>
<summary>You've inherited a huge widget with 2,000 lines. What do you do?</summary>

First, add tests around current behaviour if I can. Then split it step by step: move logic into a ViewModel, extract small widget classes, and move data access into a repository. I'd do it in small reviewable steps, rather than one giant rewrite.

</details>

<details>
<summary>The user is offline. How should the app behave?</summary>

Show cached data, with a clear offline message, rather than an empty screen. Queue changes and sync them later. Retry with backoff when the connection returns.

</details>

<details>
<summary>Design a chat app. Where do you start?</summary>

Clarify the requirements first. For data: a WebSocket stream for live messages, a repository as the source of truth, and a local database for history and offline use. For UI: a reversed lazy list, per-message status, and pagination for older messages. Also consider push notifications, reconnecting, message order, and media upload.

</details>

<details>
<summary>Design an e-commerce app's cart.</summary>

A cart repository with local persistence, synced to the server when logged in. A shared ViewModel or Bloc so all screens see the same state. The server stays the source of truth for prices and stock. Consider offline, and also the same cart on several devices.

</details>

<details>
<summary>A package you depend on is abandoned.</summary>

Check for an active fork or alternative. Keep third-party code behind my own interface, so that switching is limited to one place. As a last resort, fork and maintain it.

</details>

<details>
<summary>You need a feature with no Flutter package.</summary>

Write a platform channel, preferably with Pigeon for type safety, to the native SDK. If it's reusable, I'd package it as a plugin.

</details>

<details>
<summary>Two features need the same logic.</summary>

Move it out of the ViewModels into a repository or a domain use case, so there's one tested implementation.

</details>

<details>
<summary>The design has to work on phone and tablet.</summary>

Use `LayoutBuilder` and breakpoints, flexible widgets instead of fixed sizes, and switch navigation style on wider screens. Test on various sizes and text scales.

</details>

## Round 3: Name that error (5 minutes)

<details>
<summary><code>A RenderFlex overflowed by 42 pixels</code></summary>

The children of a Row or Column don't fit. Use `Expanded`, `Flexible`, `Wrap`, or scrolling.

</details>

<details>
<summary><code>Vertical viewport was given unbounded height</code></summary>

A `ListView` is inside a `Column` with no height limit. Wrap it in `Expanded`.

</details>

<details>
<summary><code>setState() called after dispose()</code></summary>

An async callback ran after the screen closed. Check `mounted`, and cancel timers.

</details>

<details>
<summary><code>Null check operator used on a null value</code></summary>

`!` was used on a null. Handle the null properly.

</details>

<details>
<summary><code>Incorrect use of ParentDataWidget</code></summary>

`Expanded` isn't directly in a Flex, or `Positioned` isn't directly in a Stack.

</details>

<details>
<summary><code>MissingPluginException</code></summary>

No native code answered that channel. After adding a plugin, do a full restart, rather than a hot reload.

</details>

<details>
<summary><code>setState() or markNeedsBuild() called during build</code></summary>

You changed state while drawing. Move it to a callback, or use `addPostFrameCallback`.

</details>

<details>
<summary><code>Navigator operation requested with a context that does not include a Navigator</code></summary>

The context is above the `MaterialApp`. Use a child widget, or a `Builder`.

</details>

## Round 4: Your questions for them (5 minutes)

Always have some. These are good ones:

- What does the Flutter codebase look like today, and which state management does the team use?
- How do you test and release?
- What would success look like in my first three months?
- What's the biggest technical challenge the team is facing?

## Weak spots to revisit

- [ ] Write the topics you missed here:

Next: [19 Your Story](19-your-story.md)
