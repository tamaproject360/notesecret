# NoteSecret

<div align="center">

**A privacy-first, offline-only note-taking application built with Flutter**

[![Flutter Version](https://img.shields.io/badge/Flutter-3.10.8+-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.10.8+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Windows-3DDC84?logo=android)](https://www.android.com)

*Your thoughts, secured and offline. No cloud, no tracking, just pure privacy.*

</div>

---

## 📖 Table of Contents

- [About](#about)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Development](#development)
- [Project Structure](#project-structure)
- [Design Philosophy](#design-philosophy)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 About

**NoteSecret** is a privacy-conscious, offline-first note-taking application designed to replace cloud-based alternatives like Google Keep. It prioritizes user privacy, data ownership, and a distraction-free writing experience with "Calm Technology" principles.

### Why NoteSecret?

- **100% Offline**: All data stays on your device. No internet required.
- **Zero Tracking**: No analytics, no telemetry, no third-party services.
- **Military-Grade Encryption**: AES-256 encrypted backups with password protection.
- **Biometric Security**: Vault feature with fingerprint/face authentication.
- **Minimalist Design**: "Ink on Paper" aesthetic using serif typography and earthy tones.
- **Lightning Fast**: NoSQL database (Isar) for instant search and retrieval.

---

## ✨ Features

### Core Functionality
- ✅ **Rich Note Editor**: Distraction-free writing with auto-save (2s debounce)
- ✅ **Markdown Support**: Write and preview markdown-formatted notes
- ✅ **Full-Text Search**: Real-time search across all notes (200ms debounce)
- ✅ **Organization**: Folders and tags for structured note management
- ✅ **Pin Important Notes**: Keep critical notes at the top
- ✅ **Color Coding**: Visual categorization with customizable note colors

### Security & Privacy
- ✅ **Vault Feature**: Lock sensitive notes behind biometric/PIN authentication
- ✅ **Auto-Lock**: Automatic vault locking after 30s of inactivity
- ✅ **Encrypted Backups**: AES-256 password-protected `.notesecret` files
- ✅ **Secure Storage**: PIN and sensitive data stored using flutter_secure_storage

### Data Management
- ✅ **Trash/Bin**: Soft delete with 30-day retention period
- ✅ **Export Options**: Export notes to Markdown (.md) or Plain Text (.txt)
- ✅ **Backup & Restore**: Create and restore from encrypted backups
- ✅ **Share Notes**: System share sheet integration

### User Experience
- ✅ **Dark/Light Themes**: Parchment White (Light) and Warm Black (Dark)
- ✅ **Grid/List View**: Toggle between viewing modes
- ✅ **Onboarding Flow**: 4-screen introduction for new users
- ✅ **Empty States**: Beautiful illustrations and helpful CTAs
- ✅ **Skeleton Loaders**: Smooth loading experience (no spinners)

---

## 🛠 Tech Stack

| Category | Technology | Package |
|----------|-----------|---------|
| **Framework** | Flutter 3.x | `flutter`, `dart` |
| **State Management** | Riverpod | `flutter_riverpod`, `riverpod_annotation` |
| **Routing** | GoRouter | `go_router` |
| **Database** | Isar (NoSQL) | `isar`, `isar_flutter_libs` |
| **Security** | Biometrics & Encryption | `local_auth`, `encrypt`, `flutter_secure_storage` |
| **UI/Icons** | Lucide & Google Fonts | `lucide_icons`, `google_fonts` |
| **Utilities** | Formatting & Sharing | `intl`, `uuid`, `share_plus` |
| **Markdown** | Rendering | `flutter_markdown` |
| **Notifications** | Local Notifications | `flutter_local_notifications` |

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: 3.10.8 or higher ([Download](https://flutter.dev/docs/get-started/install))
- **Dart SDK**: 3.10.8 or higher (comes with Flutter)
- **Android Studio** or **VS Code** with Flutter extensions
- **Java JDK**: 17 or higher (for Android builds)
- **Git**: For version control

Verify installation:
```bash
flutter --version
dart --version
java -version
```

---

## 🚀 Installation

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/notesecret.git
cd notesecret
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Code (Riverpod, Isar, Freezed)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run the Application
```bash
# For Android device/emulator
flutter run

# For Windows desktop
flutter run -d windows

# For specific device
flutter devices
flutter run -d <device-id>
```

---

## 💻 Development

### Development Commands

#### Run in Debug Mode
```bash
flutter run
```

#### Code Generation (Auto-watch)
```bash
# Watch mode - automatically regenerates code on file changes
dart run build_runner watch --delete-conflicting-outputs
```

#### Code Analysis
```bash
# Analyze code for linting errors
flutter analyze

# Run tests
flutter test
```

#### Build for Production
```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# Windows Desktop
flutter build windows --release
```

### Hot Reload & Hot Restart

While running `flutter run`:
- Press `r` for **hot reload** (fast UI updates)
- Press `R` for **hot restart** (full app restart)
- Press `q` to quit

---

## 📁 Project Structure

```
lib/
├── app/                        # App-wide configurations
│   ├── app.dart                # Root widget (MaterialApp)
│   ├── router/                 # GoRouter configuration
│   └── theme/                  # Design system (Colors, Typography)
├── core/                       # Core utilities and services
│   ├── auth/                   # Biometric & PIN authentication
│   ├── database/               # Isar schema & database access
│   ├── encryption/             # AES-256 encryption logic
│   └── notifications/          # Local notification service
├── features/                   # Feature modules (Screens + Logic)
│   ├── notes/                  # Note listing, editing, searching
│   │   ├── models/             # Note-related data models
│   │   ├── providers/          # Riverpod state providers
│   │   ├── repositories/       # Data access layer
│   │   └── screens/            # UI screens
│   ├── vault/                  # Locked notes feature
│   ├── folders/                # Folder & Tag management
│   ├── settings/               # App preferences & config
│   ├── backup/                 # Export/Import logic
│   ├── onboarding/             # Intro screens
│   └── splash/                 # Splash screen
├── shared/                     # Reusable components
│   ├── widgets/                # Atoms/Molecules (Buttons, Cards)
│   └── utils/                  # Helpers (Formatters, Extensions)
└── main.dart                   # Entry point

docs/
├── specs.md                    # Project specifications & guidelines
├── task.md                     # Development task list
├── changelog.md                # Version history & changes
└── design-system.xml           # UI/UX design specifications
```

---

## 🎨 Design Philosophy

NoteSecret follows the **"Calm Technology"** philosophy:

### Design Principles
1. **Content-First Hierarchy**: Notes are the hero, UI fades to the background
2. **Zero Friction**: No sign-ups, no cloud sync, instant access
3. **Thumb-Friendly Navigation**: Bottom navigation optimized for one-handed use
4. **Ink on Paper Aesthetic**: Serif typography (Lora, Merriweather) for readability

### Color System
- **Light Theme**: Parchment White (`#FAF8F5`) with Deep Charcoal (`#2C2C2C`)
- **Dark Theme**: Warm Black (`#1A1A1A`) with Soft Cream (`#E8E4DF`)
- **Accent**: Sage Green (`#6B7F5E`) for primary actions

### Typography
- **Headings**: Lora (Serif)
- **Body**: Merriweather (Serif)
- **UI Labels**: Inter (Sans-serif)
- **Code**: JetBrains Mono

### Interactions
- **Button Press**: Scale to `0.97` with 150ms duration
- **Page Transitions**: Fade + slide animations
- **Loading**: Skeleton shimmer (no circular spinners)
- **Touch Targets**: Minimum 44x44px for accessibility

For complete design specifications, see [`docs/design-system.xml`](docs/design-system.xml).

---

## 🗺 Roadmap

### ✅ Completed (v1.0.0)
- [x] Core note-taking (CRUD operations)
- [x] Full-text search with Isar indexing
- [x] Folder and tag organization
- [x] Vault with biometric/PIN authentication
- [x] Dark/Light theme system
- [x] Trash/Bin with 30-day retention
- [x] AES-256 encrypted backups
- [x] Export to Markdown/Plain Text
- [x] Onboarding flow
- [x] Local notifications for reminders

### 🔄 In Progress
- [ ] Motion polish (audit all animations)
- [ ] QA checklist (accessibility, performance)

### 🔮 Future Enhancements (v2.0+)
- [ ] Windows Desktop support
- [ ] Handwriting recognition
- [ ] Voice memos attachment
- [ ] Advanced markdown editor with live preview
- [ ] Customizable themes and color palettes
- [ ] Note templates
- [ ] Import from other apps (Google Keep, Evernote)

---

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

### Reporting Bugs
1. Check existing [Issues](https://github.com/yourusername/notesecret/issues)
2. Create a new issue with:
   - Clear description of the bug
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots (if applicable)
   - Device/OS information

### Development Workflow
1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Follow** code style guidelines (see `docs/specs.md`)
4. **Test** your changes thoroughly
5. **Commit** with descriptive messages (`git commit -m 'feat: add amazing feature'`)
6. **Push** to your branch (`git push origin feature/amazing-feature`)
7. **Open** a Pull Request

### Code Style
- Follow `analysis_options.yaml` linting rules
- Use 2 spaces for indentation
- Prefer `final` and `const` where possible
- Write descriptive variable/function names
- Add comments for complex logic only

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Design Inspiration**: Apple Notes, Bear, Obsidian
- **Icons**: [Lucide Icons](https://lucide.dev)
- **Fonts**: [Google Fonts](https://fonts.google.com)
- **Community**: Flutter & Riverpod communities

---

## 📞 Contact

**Project Maintainer**: [Your Name](https://github.com/yourusername)

**Issues**: [GitHub Issues](https://github.com/yourusername/notesecret/issues)

**Documentation**: [Project Wiki](https://github.com/yourusername/notesecret/wiki)

---

<div align="center">

**Made with ❤️ using Flutter**

*Privacy is not a feature, it's a fundamental right.*

</div>
