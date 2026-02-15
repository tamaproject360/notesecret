# Repository Guidelines

## Project Overview
**NoteSecret** is a privacy-first, offline-only note-taking application designed to replace cloud-based alternatives like Google Keep. It prioritizes "Calm Technology," ensuring zero friction, thumb-friendly navigation, and a content-first hierarchy.

- **Core Utility**: Secure, offline note-taking with AES-256 encrypted backups.
- **Target Audience**: Privacy-conscious users, journalists, and professionals.
- **Design Philosophy**: Minimalist, "Ink on Paper" feel using Serif typography and earthy tones.
- **Platform**: Android (Primary), adaptable to Windows Desktop.

## Tech Stack
The project is built using **Flutter 3.x** and **Dart**, focusing on performance, offline capability, and security.

| Category | Technology | Package/Library |
|----------|------------|-----------------|
| **Framework** | Flutter | `flutter`, `dart` |
| **State Management** | Riverpod | `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator` |
| **Routing** | GoRouter | `go_router` |
| **Local Database** | Isar (NoSQL) | `isar`, `isar_flutter_libs` |
| **Security (Storage)** | Secure Storage | `flutter_secure_storage` |
| **Security (Auth)** | Biometrics | `local_auth` |
| **Encryption** | AES-256 | `encrypt` |
| **UI/Icons** | Lucide & SVG | `lucide_icons`, `flutter_svg`, `google_fonts` |
| **Utilities** | Formatting/Utils | `intl`, `uuid`, `path_provider`, `share_plus` |
| **Rendering** | Markdown | `flutter_markdown` |
| **Notifications** | Local Notifications | `flutter_local_notifications` |
| **Code Gen** | Build Runner | `build_runner`, `freezed`, `json_serializable` |

## Folder & File Project Structure
The project follows a **Feature-First Architecture** combined with a Clean Architecture approach within features.

```
lib/
├── app/                        # App-wide configurations
│   ├── app.dart                # Root widget (MaterialApp)
│   ├── router/                 # GoRouter configuration
│   └── theme/                  # Design system implementation (ThemeData, Colors, Type)
├── core/                       # Core utilities and distinct layers
│   ├── auth/                   # Biometric & PIN logic
│   ├── database/               # Isar schema & low-level db access
│   ├── encryption/             # AES encryption logic
│   └── notifications/          # Local notification service
├── features/                   # Functional modules (Screens + Logic)
│   ├── notes/                  # Note listing, editing, searching
│   ├── vault/                  # Locked notes logic
│   ├── folders/                # Folder & Tag management
│   ├── settings/               # App preferences & config
│   ├── backup/                 # Export/Import logic
│   ├── onboarding/             # Intro screens
│   └── splash/                 # Splash screen
├── shared/                     # Reusable components
│   ├── widgets/                # Atoms/Molecules (Buttons, Cards, Inputs)
│   └── utils/                  # Helpers (Date formatters, Extensions)
└── main.dart                   # Entry point
```

## Commands
Common commands used for development and maintenance.

### Development
```bash
# Run app in debug mode
flutter run

# Get dependencies
flutter pub get

# Run code generation (Riverpod/Isar/Freezed)
dart run build_runner build --delete-conflicting-outputs

# Watch for changes during development (Auto-generate code)
dart run build_runner watch --delete-conflicting-outputs
```

### Analysis & Testing
```bash
# Analyze code for linting errors
flutter analyze

# Run unit and widget tests
flutter test
```

## Code Style

### Dart
- **Strict Typing**: Avoid `dynamic` unless absolutely necessary.
- **Immutability**: Prefer `final` for variables and `const` for constructors/widgets where possible.
- **Async/Await**: Use `async`/`await` over raw `Future.then` chains.
- **Linting**: Adhere to `flutter_lints` rules configured in `analysis_options.yaml`.

### Flutter Components
- **Composition**: Break down large widgets into smaller, focused `StatelessWidget`s.
- **Hooks/Consumer**: Use `ConsumerWidget` (Riverpod) for state consumption.
- **Private Widgets**: Prefix private sub-widgets within the same file with `_`.
- **Param Order**: Key arguments first (e.g., `onPressed`), then child/children, then styling.

### Imports
Organize imports in the following order:
1.  **Dart Core**: `import 'dart:async';`
2.  **Flutter/Packages**: `import 'package:flutter/material.dart';`
3.  **App Core/Shared**: `import 'package:notesecret/core/...';`
4.  **Relative Imports**: `import './widget.dart';` (Use strictly for files in the same feature directory, otherwise use absolute package imports).

### Naming Conventions
- **Classes/Types**: `PascalCase` (e.g., `NoteEditor`, `BackupService`).
- **Variables/Functions**: `camelCase` (e.g., `isLoading`, `saveNote`).
- **Files**: `snake_case` (e.g., `note_editor.dart`, `app_theme.dart`).
- **Constants**: `lowerCamelCase` (preferred in Dart) or `SCREAMING_SNAKE_CASE` for truly global constants.
- **Private Members**: Prefix with underscore `_` (e.g., `_calculateTotal`).

### Error Handling
- **Result Type**: Use functional error handling where possible or standard `try/catch` blocks in Repository layers.
- **AsyncValue**: In UI, handle Riverpod `AsyncValue` states consistently:
    ```dart
    ref.watch(provider).when(
      data: (data) => Content(data),
      loading: () => SkeletonLoader(),
      error: (e, st) => ErrorView(e),
    );
    ```
- **User Feedback**: Errors should trigger a **Toast/Snackbar** (as defined in UI guidelines), not console logs alone.

## UI Components
All UI components must adhere to the **NoteSecret Design System** (`docs/design-system.xml`).

- **Typography**:
    - Headings: **Lora** (Serif)
    - Body: **Merriweather** (Serif)
    - UI Labels: **Inter** (Sans-serif)
    - Code: **JetBrains Mono**
- **Colors**:
    - **Light**: Parchment White (`#FAF8F5`) bg, Deep Charcoal (`#2C2C2C`) text.
    - **Dark**: Warm Black (`#1A1A1A`) bg, Soft Cream (`#E8E4DF`) text.
    - **Accent**: Sage Green (`#6B7F5E`) - Used strictly for primary actions.
- **Key Atoms**:
    - **Buttons**: Scale to `0.97` on press. No ripple needed if using custom scale.
    - **Cards**: rounded-`16px`, subtle shadow, "soft cream" background.
    - **Inputs**: Filled box, rounded-`12px`, floating label, no outline borders.
    - **Loaders**: Skeleton shimmer only. **NO** circular spinners.

## Accessibility
- **Touch Targets**: All interactive elements must be at least **44x44px**.
- **Contrast**: Maintain WCAG AA compliance for text readability (High contrast text on Parchment/Black backgrounds).
- **Text Scaling**: UI must respect system font size settings (use `textScaleFactor` awareness or scrollable wrappers).
- **Semantics**: Use `Semantics` widgets for complex custom interactions (like drag-and-drop) to ensure screen reader support.
