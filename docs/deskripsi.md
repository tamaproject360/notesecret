# NoteSecret v1.0.0 - Initial Release

**Your Notes. Your Privacy.**

---

## 🎉 Release Highlights

We're excited to announce the first official release of **NoteSecret** - a privacy-first, offline-only note-taking application built with Flutter. This release brings a complete, production-ready experience for Android and Windows Desktop users who value privacy and data ownership.

---

## 📱 What is NoteSecret?

NoteSecret is a **privacy-conscious, offline-first note-taking app** designed to replace cloud-based alternatives like Google Keep. It prioritizes user privacy, data ownership, and a distraction-free writing experience with "Calm Technology" principles.

### Core Values
- ✅ **100% Offline** - All data stays on your device. No internet required.
- ✅ **Zero Tracking** - No analytics, no telemetry, no third-party services.
- ✅ **Military-Grade Security** - AES-256 encrypted backups with password protection.
- ✅ **Your Data, Your Control** - Export, backup, and migrate your notes anytime.

---

## ✨ Key Features

### 📝 Note-Taking
- **Rich Text Editor** - Distraction-free writing with auto-save (2s debounce)
- **Markdown Support** - Write and preview markdown-formatted notes
- **Full-Text Search** - Real-time search across all notes (200ms debounce)
- **Organization** - Folders and tags for structured note management
- **Pin Important Notes** - Keep critical notes at the top
- **Color Coding** - Full background color cards with smart text contrast
- **Masonry Layout** - Pinterest-style staggered grid (Google Keep UI)
- **Grid/List View** - Toggle between viewing modes

### 🔐 Security & Privacy
- **Vault Feature** - Lock sensitive notes behind biometric/PIN authentication
- **Auto-Lock** - Automatic vault locking after 30s of inactivity
- **Encrypted Backups** - AES-256 password-protected `.notesecret` files
- **Secure Storage** - PIN and sensitive data stored using flutter_secure_storage
- **No Cloud Sync** - 100% offline, zero external connections
- **No Tracking** - Zero analytics, telemetry, or third-party services

### 💾 Data Management
- **Trash/Bin** - Soft delete with 30-day retention period
- **Export Options** - Export notes to Markdown (.md) or Plain Text (.txt)
- **Backup & Restore** - Create and restore from encrypted backups with UI
- **Share Notes** - System share sheet integration
- **File Picker** - Easy backup file selection for restore

### 🎨 User Experience
- **Dark/Light Themes** - Parchment White (Light) and Warm Black (Dark)
- **System Theme** - Auto-match system appearance
- **Onboarding Flow** - 4-screen introduction for new users
- **Empty States** - Beautiful illustrations and helpful CTAs
- **Skeleton Loaders** - Smooth loading experience (no spinners)
- **Button Animations** - Scale to 0.97 on press (150ms)
- **Responsive UI** - Optimized for both mobile and desktop

### 🖥️ Cross-Platform Support
- **Android** - Full support for Android 5.0+ (API 21 and above)
- **Windows Desktop** - Native Windows 10/11 (x64) application
- **Same Features** - Full feature parity across platforms
- **Responsive Design** - Adapts to different screen sizes

---

## 📦 Downloads

### Android APK
**File**: `notesecret-v1.0.0-android.apk`
- **Min SDK**: Android 5.0 (API 21) and above
- **Target SDK**: Android 14 (API 34)
- **Architecture**: Universal (arm64-v8a, armeabi-v7a, x86_64)
- **Size**: ~30-40 MB
- **Checksum (SHA256)**: `[Will be added after build]`

**Installation:**
1. Download the APK file
2. Enable "Install from Unknown Sources" in Android Settings
3. Open the downloaded APK file
4. Follow the installation prompts
5. Launch NoteSecret and start taking notes!

### Windows Desktop
**File**: `notesecret-v1.0.0-windows-x64.zip`
- **Platform**: Windows 10/11 (x64)
- **Size**: ~25-35 MB (compressed)
- **Checksum (SHA256)**: `[Will be added after build]`

**Installation:**
1. Download and extract the ZIP file
2. Run `notesecret.exe` from the extracted folder
3. (Optional) Create a desktop shortcut for quick access

---

## 🛠 Technical Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.38.9 + Dart 3.10.8 |
| **State Management** | Riverpod 2.6.1 |
| **Database** | Isar 3.1.0 (NoSQL) |
| **Security** | AES-256, Biometrics, Secure Storage |
| **UI/Icons** | Lucide Icons, Google Fonts |
| **Layout** | Staggered Grid View (Masonry) |

---

## 📋 System Requirements

### Android
- **OS**: Android 5.0 (Lollipop) or higher
- **RAM**: 2GB minimum, 4GB recommended
- **Storage**: 100MB free space
- **Permissions**: Storage (for backup/restore), Biometric (optional)

### Windows
- **OS**: Windows 10 (64-bit) or Windows 11
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 200MB free space
- **Architecture**: x64 only

---

## 🎨 Design Philosophy

NoteSecret follows the **"Calm Technology"** philosophy with three core design pillars:

1. **Zero Friction** - No login, no onboarding walls, no mandatory permissions. Open → Write.
2. **Thumb-Zone Architecture** - All primary actions within natural thumb reach (bottom 60% of screen)
3. **Content-First Hierarchy** - UI chrome is minimal. The note content is the hero.

### Visual Identity
- **Typography**: Serif fonts (Lora & Merriweather) for an "Ink on Paper" feel
- **Colors**: Earthy tones - Parchment White, Sage Green, Deep Charcoal
- **Interactions**: Subtle animations with 150ms scale transforms
- **Layout**: Google Keep-inspired masonry grid with full-color cards

---

## 🚀 What's New in v1.0.0

### Core Features
✅ Complete note CRUD operations with auto-save  
✅ Full-text search with Isar indexing (200ms debounce)  
✅ Folder and tag organization system  
✅ Vault feature with biometric/PIN authentication  
✅ Dark/Light/System theme modes  
✅ Trash/Bin with 30-day retention  
✅ AES-256 encrypted backups with password protection  
✅ Export to Markdown (.md) and Plain Text (.txt)  
✅ Onboarding flow (4 screens)  
✅ Local notifications for reminders  

### UI/UX Enhancements
✅ Pinterest/Masonry layout (Google Keep style)  
✅ Full background color cards with smart contrast  
✅ Skeleton shimmer loaders (no spinners)  
✅ Bottom navigation for thumb-friendly access  
✅ Empty states with beautiful illustrations  
✅ Responsive design for mobile and desktop  

### Cross-Platform
✅ Android support (API 21+)  
✅ Windows Desktop support (Windows 10/11 x64)  
✅ Full feature parity across platforms  

### Developer Experience
✅ Feature-first architecture  
✅ Riverpod for state management  
✅ Isar NoSQL database  
✅ Code generation with build_runner  
✅ Comprehensive documentation  

---

## 📸 Screenshots

*Screenshots will be available in the repository's `screenshots/` folder*

---

## 🔮 Roadmap - What's Next?

### v1.1.0 (Planned)
- [ ] Advanced markdown editor with live preview
- [ ] Note templates
- [ ] Customizable color palettes
- [ ] Widget support (Android/Windows)

### v2.0.0 (Future)
- [ ] iOS/macOS support
- [ ] Linux desktop support
- [ ] Handwriting recognition
- [ ] Voice memos attachment
- [ ] Import from Google Keep/Evernote

---

## 🐛 Known Issues

- None reported for v1.0.0 initial release

If you encounter any bugs, please report them on our [GitHub Issues](https://github.com/yourusername/notesecret/issues) page.

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

- 🐛 **Report bugs** via GitHub Issues
- 💡 **Suggest features** via GitHub Discussions
- 🔧 **Submit pull requests** for bug fixes or enhancements
- 📖 **Improve documentation**
- ⭐ **Star the repository** to show your support

See [CONTRIBUTING.md](../CONTRIBUTING.md) for detailed guidelines.

---

## 📄 License

NoteSecret is open-source software licensed under the **MIT License**.

You are free to:
- ✅ Use commercially
- ✅ Modify
- ✅ Distribute
- ✅ Use privately

See [LICENSE](../LICENSE) for full terms.

---

## 🙏 Acknowledgments

- **Design Inspiration**: Apple Notes, Bear, Obsidian, Google Keep
- **Icons**: [Lucide Icons](https://lucide.dev)
- **Fonts**: [Google Fonts](https://fonts.google.com) (Lora, Merriweather, Inter)
- **Community**: Flutter & Riverpod communities
- **Special Thanks**: All early testers and contributors

---

## 📞 Support & Contact

- **Documentation**: [Project Wiki](https://github.com/yourusername/notesecret/wiki)
- **Issues**: [GitHub Issues](https://github.com/yourusername/notesecret/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/notesecret/discussions)
- **Email**: your.email@example.com

---

## 🌟 Show Your Support

If you like NoteSecret, please:
- ⭐ **Star the repository** on GitHub
- 🐦 **Share on social media**
- 📝 **Write a review** or blog post
- 💬 **Tell your friends** about privacy-first note-taking

---

**Made with ❤️ using Flutter**

*Privacy is not a feature, it's a fundamental right.*

---

## Verification (SHA256 Checksums)

```bash
# Android APK
[Checksum will be added after build]

# Windows x64
[Checksum will be added after build]
```

**How to verify:**
```bash
# Linux/Mac
sha256sum notesecret-v1.0.0-android.apk

# Windows PowerShell
Get-FileHash notesecret-v1.0.0-windows-x64.zip -Algorithm SHA256
```

---

**Release Date**: February 15, 2026  
**Version**: 1.0.0  
**Build**: 1  
**Flutter**: 3.38.9  
**Dart**: 3.10.8
