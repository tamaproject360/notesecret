# NoteSecret

<div align="center">

**A privacy-first, offline-only note-taking application built with Flutter**

[![Flutter Version](https://img.shields.io/badge/Flutter-3.10.8+-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.10.8+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Windows-3DDC84?logo=android)](https://www.android.com)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg)](https://github.com/yourusername/notesecret/releases)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-success.svg)](https://github.com/yourusername/notesecret)

*Your thoughts, secured and offline. No cloud, no tracking, just pure privacy.*

[Features](#features) • [Installation](#installation) • [Download](#download) • [Documentation](#documentation)

</div>

---

## 📖 Table of Contents

- [About](#about)
- [Features](#features)
- [Screenshots](#screenshots)
- [Download](#download)
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
- **Cross-Platform**: Full support for Android and Windows Desktop.
- **Google Keep Style**: Minimalist design with Pinterest/Masonry layout.
- **Lightning Fast**: NoSQL database (Isar) for instant search and retrieval.

---

## ✨ Features

### 🎨 Core Functionality
- ✅ **Rich Note Editor**: Distraction-free writing with auto-save (2s debounce)
- ✅ **Markdown Support**: Write and preview markdown-formatted notes
- ✅ **Full-Text Search**: Real-time search across all notes (200ms debounce)
- ✅ **Organization**: Folders and tags for structured note management
- ✅ **Pin Important Notes**: Keep critical notes at the top
- ✅ **Color Coding**: Full background color cards with smart text contrast
- ✅ **Masonry Layout**: Pinterest-style staggered grid (Google Keep UI)
- ✅ **Grid/List View**: Toggle between viewing modes

### 🔐 Security & Privacy
- ✅ **Vault Feature**: Lock sensitive notes behind biometric/PIN authentication
- ✅ **Auto-Lock**: Automatic vault locking after 30s of inactivity
- ✅ **Encrypted Backups**: AES-256 password-protected `.notesecret` files
- ✅ **Secure Storage**: PIN and sensitive data stored using flutter_secure_storage
- ✅ **No Cloud Sync**: 100% offline, zero external connections
- ✅ **No Tracking**: Zero analytics, telemetry, or third-party services

### 💾 Data Management
- ✅ **Trash/Bin**: Soft delete with 30-day retention period
- ✅ **Export Options**: Export notes to Markdown (.md) or Plain Text (.txt)
- ✅ **Backup & Restore**: Create and restore from encrypted backups with UI
- ✅ **Share Notes**: System share sheet integration
- ✅ **File Picker**: Easy backup file selection for restore

### 🎨 User Experience
- ✅ **Dark/Light Themes**: Parchment White (Light) and Warm Black (Dark)
- ✅ **System Theme**: Auto-match system appearance
- ✅ **Onboarding Flow**: 4-screen introduction for new users
- ✅ **Empty States**: Beautiful illustrations and helpful CTAs
- ✅ **Skeleton Loaders**: Smooth loading experience (no spinners)
- ✅ **Button Animations**: Scale to 0.97 on press (150ms)
- ✅ **Responsive UI**: Optimized for both mobile and desktop

### 🖥️ Cross-Platform
- ✅ **Android Support**: API 21+ (Android 5.0 Lollipop and above)
- ✅ **Windows Desktop**: Windows 10/11 (x64)
- ✅ **Same Features**: Full feature parity across platforms
- ✅ **Responsive Design**: Adapts to different screen sizes

---

## 📱 Screenshots

*Coming soon - Screenshots will be added in the next update*

---

## 📥 Download

### Latest Release

📦 **[Download from GitHub Releases](https://github.com/tamaproject360/notesecret/releases/latest)**

### Android APK
- **Download**: [notesecret-v1.0.0-android.apk](https://github.com/tamaproject360/notesecret/releases/latest)
- **Min SDK**: Android 5.0 (API 21) and above
- **Target SDK**: Android 14 (API 34)
- **Architecture**: Universal (arm64-v8a, armeabi-v7a, x86_64)
- **Size**: ~30-40 MB

**Installation Steps:**
1. Download the APK file from [GitHub Releases](https://github.com/tamaproject360/notesecret/releases)
2. Enable "Install from Unknown Sources" in Android Settings
3. Open the downloaded APK file
4. Follow the installation prompts
5. Launch NoteSecret and start taking notes!

### Windows Desktop
- **Download**: [notesecret-v1.0.0-windows-x64.zip](https://github.com/tamaproject360/notesecret/releases/latest)
- **Platform**: Windows 10/11 (x64)
- **Size**: ~25-35 MB (compressed)

**Installation Steps:**
1. Download the ZIP file from [GitHub Releases](https://github.com/tamaproject360/notesecret/releases)
2. Extract the ZIP file to your preferred location
3. Run `notesecret.exe`
4. (Optional) Create a desktop shortcut for quick access

### Build from Source
See [Installation](#installation) section below for instructions on building from source.

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
| **UI/Layout** | Masonry Grid | `flutter_staggered_grid_view` |
| **Utilities** | Formatting & Sharing | `intl`, `uuid`, `share_plus`, `file_picker` |
| **Markdown** | Rendering | `flutter_markdown` |
| **Notifications** | Local Notifications | `flutter_local_notifications` |

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: 3.10.8 or higher ([Download](https://flutter.dev/docs/get-started/install))
- **Dart SDK**: 3.10.8 or higher (comes with Flutter)
- **Android Studio** or **VS Code** with Flutter extensions
- **Java JDK**: 17 or higher (for Android builds)
- **Visual Studio 2022**: With "Desktop development with C++" (for Windows builds)
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

**Android**:
```bash
flutter run
```

**Windows Desktop**:
```bash
flutter run -d windows
```

**Select Specific Device**:
```bash
flutter devices
flutter run -d <device-id>
```

---

## 💻 Development

### Development Commands

#### Run in Debug Mode
```bash
# Android
flutter run

# Windows
flutter run -d windows
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

**Android**:
```bash
# APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

**Windows**:
```bash
# Desktop executable
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
│   ├── backup/                 # Backup & restore services
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
5. **Google Keep Inspired**: Masonry layout with full background color cards

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

### ✅ Completed (v1.0.0 - February 15, 2026)
- [x] Core note-taking (CRUD operations)
- [x] Full-text search with Isar indexing
- [x] Folder and tag organization
- [x] Vault with biometric/PIN authentication
- [x] Dark/Light/System theme modes
- [x] Trash/Bin with 30-day retention
- [x] AES-256 encrypted backups with UI
- [x] Export to Markdown/Plain Text
- [x] Onboarding flow (4 screens)
- [x] Local notifications for reminders
- [x] Pinterest/Masonry layout (Google Keep style)
- [x] Full background color cards with smart contrast
- [x] Windows Desktop support
- [x] Cross-platform compatibility (Android + Windows)
- [x] Backup & Restore UI in Settings

### 🔮 Future Enhancements (v2.0+)
- [ ] iOS/macOS support
- [ ] Linux desktop support
- [ ] Handwriting recognition
- [ ] Voice memos attachment
- [ ] Advanced markdown editor with live preview
- [ ] Customizable themes and color palettes
- [ ] Note templates
- [ ] Import from other apps (Google Keep, Evernote)
- [ ] Collaborative features (offline P2P sync)
- [ ] Widget support (Android/Windows)

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

- **Design Inspiration**: Apple Notes, Bear, Obsidian, Google Keep
- **Icons**: [Lucide Icons](https://lucide.dev)
- **Fonts**: [Google Fonts](https://fonts.google.com)
- **Community**: Flutter & Riverpod communities
- **Special Thanks**: All contributors and testers

---

## 📞 Contact

**Project Maintainer**: [tamaproject360](https://github.com/tamaproject360)

**Issues**: [GitHub Issues](https://github.com/tamaproject360/notesecret/issues)

**Documentation**: [Project Wiki](https://github.com/tamaproject360/notesecret/wiki)

**Email**: tamaproject360@gmail.com

---

## 🌟 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=ytamaproject360/notesecret&type=Date)](https://star-history.com/tamaproject360/notesecret&Date)

---

<div align="center">

**Made with ❤️ using Flutter**

*Privacy is not a feature, it's a fundamental right.*

**[⬆ Back to Top](#notesecret)**

</div>
