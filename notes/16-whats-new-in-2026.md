[Guide home](../README.md) · Back: [15 Native Packages and Release](15-native-packages-and-release.md) · Next: [17 Live Coding Practice](17-live-coding-practice.md)

# What's New in 2026

**Why this matters:** "What's new in Flutter?" is an easy chance to show you keep up. This was checked against the official blog and docs on 31 October 2026.

**Current versions:** Flutter 3.47.9, Dart 3.13.7.

## The five things to mention

### 1. Material and Cupertino are moving out

`material_ui` and `cupertino_ui` reached 1.0 on pub.dev, and using them is optional for now. They can get updates without waiting for a Flutter release.

- The versions inside the framework still work, but formal deprecation was announced for the November stable release.
- To migrate: `dart fix --apply --code=migrate_design_widgets`

> [!TIP]
> **Say it like this**
>
> "Design libraries are being split out of the framework into `material_ui` and `cupertino_ui`, so they can ship updates independently. There's a `dart fix` migration."

### 2. Primary constructors (Dart 3.13)

```dart
class Point(final int x, final int y);
```

This declares the fields and constructor in one line. There's an example in `bin/d02_oop.dart`.

### 3. Impeller is the default on desktop

As of Flutter 3.47, it's the default on Windows, macOS and Linux, alongside iOS and modern Android. The web doesn't use it.

### 4. Widget Previews are stable

See and test widgets in isolation in your editor, without running the whole app.

### 5. AI tools

| Tool | Job |
|---|---|
| Dart and Flutter **MCP server** | Lets coding agents analyse code, hot reload and more |
| `genui` | Lets AI agents compose UI at runtime |
| `firebase_ai` | Calls Gemini from your app |
| Genkit Dart | A model-agnostic AI toolkit, in preview |

## Also useful

| Area | What changed |
|---|---|
| **Web** | Moving toward WebAssembly: `flutter build web --wasm`. Wasm needs `package:web`, not `dart:html` |
| **iOS** | Swift Package Manager is replacing CocoaPods. Apps built with Xcode 27 must adopt the UIScene lifecycle |
| **Android** | Verified toolchain: Java 17, AGP 9.1.0, Gradle 9.3.1, KGP 2.4.0. Defaults: minSdk 24, targetSdk 36 |
| **Desktop** | Canonical is the lead maintainer. Flavors now work on Windows and Linux |
| **Security** | 3.47.8 blocks compromised eMudhra CA keys, so use that version or later |
| **Dart language** | Dot shorthands (`.delivered`) and null-aware elements (`?maybeTag`) |
| **Threads** | Since 3.29, UI and platform threads are merged on iOS and Android |

> [!WARNING]
> **Don't overclaim**
>
> Only say you've *used* these if you have. "I've been following this, and tried it in a practice project" is honest and still impressive. You really have run primary constructors and dot shorthands in your lab now.

## Test yourself

<details>
<summary>What's new in recent Flutter releases?</summary>

Material and Cupertino are moving to standalone packages, so they can update independently. Impeller is now the default on desktop. Widget Previews are stable, and web is moving toward WebAssembly. In Dart 3.13, primary constructors let you declare fields and a constructor in one line.

</details>

<details>
<summary>What should a new app do about <code>material_ui</code>?</summary>

The core libraries still work today, but deprecation has been announced. So I'd check the current release notes, and either start on the new packages or plan a `dart fix` migration.

</details>

<details>
<summary>Does Flutter web use Impeller?</summary>

No. As of the current docs, the web doesn't use Impeller.

</details>

## Sources

- [What's new in Flutter 3.47](https://flutter.dev/blog/whats-new-in-flutter-3-47)
- [Announcing Dart 3.13](https://dart.dev/blog/announcing-dart-3-13)
- [Impeller docs](https://docs.flutter.dev/perf/impeller)

Next: [17 Live Coding Practice](17-live-coding-practice.md)
