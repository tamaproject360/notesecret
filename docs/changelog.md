# Changelog - NoteSecret

## [v1.0.1] - 2026-02-15

### Fixed
- **Restore Backup**: Fixed file picker issue on Android by allowing all file types (bypassing OS extension filters).
- **Tag Saving**: Fixed critical bug where tags were not persisting to the database (added manual `IsarLinks.save()`).
- **Vault Security**: Replaced simulated PIN dialog with active verification against stored credentials.
- **Move to Folder**: 
    - Added visual Folder Chip in Note Editor for better feedback.
    - Fixed folder selection persistence by invalidating provider state.

### Added
- **Folder Detail View**: New screen to view notes within a specific folder.
- **Add to Folder**: Ability to add existing notes to a folder directly from the Folder Detail screen via Floating Action Button.

## [v1.0.0] - 2026-02-15 - Initial Release

### ✅ Phase 1-3: Foundation & Core Features (Completed)
- **Project Setup**: Flutter project initialized with strict typing and git repository
- **Dependencies**: All core packages added (Riverpod, Isar, Google Fonts, Lucide Icons, etc.)
- **Theming**: Light/Dark mode with Parchment White and Warm Black color schemes
- **Routing**: GoRouter implementation with bottom navigation
- **Database**: Isar NoSQL database with Note, Folder, Tag models
- **UI Components**: 
  - Reusable widgets (Buttons, Input Fields, Note Cards, Skeleton Loaders)
  - Bottom Navigation Bar with active/inactive states
  - Feedback systems (Snackbar, BottomSheet)
- **Notes Management**:
  - Home Dashboard with Masonry/List toggle (Pinterest-style layout)
  - Note Editor with auto-save (2s debounce)
  - CRUD operations (Create, Read, Update, Soft Delete)
  - Pinned notes section
  - Empty states with illustrations
  - Full background color cards with smart text contrast

### ✅ Phase 4: Security & Privacy (Completed)
- ✅ **Biometrics & PIN**: Implemented `local_auth` for fingerprint/face authentication
- ✅ **Vault Feature**: Locked notes accessible only via biometric/PIN
- ✅ **Auto-Lock**: App lifecycle observer for automatic vault locking on background (30s timeout)
- ✅ **Auth Service**: Complete PIN management with flutter_secure_storage
- ✅ **Encryption**: AES-256 encryption for backups

### ✅ Phase 5: Organization & Search (Completed)
- ✅ **Folder System**: 
  - Complete CRUD operations for folders
  - Folder repository and Riverpod provider
  - Emoji picker with 8 icon options (📁📂🗂️📚📖📝💼🎯)
  - Create/Delete folders with confirmation
  - Empty state with call-to-action
  - Folders Screen UI (`folders_screen.dart`)
- ✅ **Search Engine**: 
  - Full-text search with Isar indexing
  - Real-time search with 200ms debounce
  - Search screen with empty states
  - Search in note title and body (case-insensitive)
- ✅ **Tagging System**: 
  - Tag creation and management
  - Filter notes by tags
  - Tag provider with Riverpod
  - Optimized Isar queries for tag filtering

### ✅ Phase 6: Data Management & Settings (100% Complete)
- ✅ **Settings UI**: 
  - Comprehensive settings screen with sections
  - Appearance: Light/Dark/System theme selector
  - Security: PIN management, Biometric toggle
  - Data: Backup, Restore, Trash
  - About: Version info, developer credits
  - Clean Material 3 design
- ✅ **Trash/Bin**: 
  - Trash screen with deleted notes list
  - Restore functionality
  - Permanent delete with confirmation
  - 30-day warning banner
  - Date formatting (today, yesterday, X days ago)
- ✅ **Export Service**: 
  - Export to Markdown (.md)
  - Export to Plain Text (.txt)
  - Single note export via Share sheet
  - Multiple notes export
  - File name sanitization
  - Service: `export_service.dart`
- ✅ **Backup & Restore**: 
  - AES-256 encrypted backup generation
  - Create .notesecret backup files
  - Password-protected encryption
  - Restore from encrypted backup with file picker
  - Parse notes and folders from backup
  - Share backup via system share sheet
  - Full UI integration in Settings screen
  - Services: `backup_service.dart`, `backup_provider.dart`

### ✅ Phase 7: Onboarding & Polish (100% Complete)
- ✅ **Onboarding Flow**: 
  - 4-screen PageView with smooth transitions
  - Welcome, Offline First, Lock, Start Writing screens
  - Skip button functionality
  - Animated dot indicators
  - Get Started CTA
  - Beautiful illustrations with Lucide icons
  - `onboarding_screen.dart`
- ✅ **Splash Screen**: Auto-navigate with branding
- ✅ **Motion Polish**: Button press animations (scale 0.97), smooth transitions
- ✅ **UI/UX Polish**: Google Keep-style masonry layout, full background colors

### 🐛 Bug Fixes
- Fixed Gradle build errors (core library desugaring, namespace conflicts)
- Fixed CardTheme/CardThemeData type compatibility
- Fixed splash screen navigation (auto-navigate to home after 1.5s)
- Updated flutter_local_notifications to v17.2.4 (resolved compilation errors)
- **[2026-02-15]** Fixed `tag_filter_provider.dart` compilation error:
  - Added missing `import 'package:isar/isar.dart'` for `findAll()` method
  - Optimized filter implementation using Isar queries instead of manual filtering
  - Improved performance by filtering at database level with `.filter().tags()`
  - Now properly excludes deleted/locked notes and sorts by date efficiently

### 🎨 UI/UX Improvements
- **[2026-02-15]** Redesigned note cards with full background color:
  - Note color now fills entire card background (Google Keep style)
  - Removed left color strip, replaced with full background
  - Smart text contrast: automatically adjusts text color based on background brightness
  - Added subtle border for cards without custom colors
  - Improved shadow for better depth perception
- **[2026-02-15]** Implemented Pinterest/Masonry layout:
  - Replaced fixed-height grid with dynamic masonry layout
  - Cards now auto-size based on content length (like Google Keep)
  - More efficient space usage with staggered grid view
  - Smooth scrolling performance
  - Package: `flutter_staggered_grid_view ^0.7.0`

### ✨ New Features
- **[2026-02-15]** Added Backup & Restore UI to Settings:
  - Create encrypted backups with AES-256 encryption
  - Password-protected .notesecret backup files
  - Restore from backup with password verification
  - File picker integration for selecting backup files
  - Share backup files via system share sheet
  - User-friendly dialogs with password confirmation
  - Success/error feedback with SnackBar
  - Package: `file_picker ^8.0.0`
- **[2026-02-15]** Windows Desktop Support:
  - Enabled Windows desktop platform
  - Full cross-platform compatibility (Android + Windows)
  - Same features available on both platforms
  - Responsive UI for desktop screens
  - Native Windows executable build support
  - Desktop-optimized file picker

### 📝 Documentation
- Created `docs/specs.md` with comprehensive project guidelines
- Updated `docs/task.md` with complete progress tracking
- Created professional `README.md` with industry standards
- Maintained consistent commit history
- Added development guidelines and contribution guide

### 🔧 Technical Improvements
- Android build configuration optimized (AGP 8+, Java 17)
- Code generation setup (Riverpod, Isar, Freezed)
- Proper error handling and state management
- Material 3 design system implementation
- Cross-platform compatibility (Android + Windows)
- Repository pattern for data access
- Provider pattern for state management
- Efficient database queries with Isar

### 📦 Dependencies Added
- Core: `flutter_riverpod`, `riverpod_annotation`, `isar`, `isar_flutter_libs`
- UI: `google_fonts`, `lucide_icons`, `flutter_staggered_grid_view`
- Storage: `flutter_secure_storage`, `path_provider`
- Security: `local_auth`, `encrypt`
- Utilities: `share_plus`, `file_picker`, `intl`, `uuid`
- Routing: `go_router`
- Markdown: `flutter_markdown`
- Notifications: `flutter_local_notifications`

---

## 🎯 Completed Milestones

✅ **All 7 Development Phases Completed**
- Phase 1-3: Foundation & Core Features
- Phase 4: Security & Privacy
- Phase 5: Organization & Search
- Phase 6: Data Management & Settings
- Phase 7: Onboarding & Polish

✅ **Production Ready**
- Full feature parity with Google Keep
- Cross-platform support (Android + Windows)
- Enterprise-grade security (AES-256 encryption)
- Offline-first architecture
- Privacy-focused (no cloud, no tracking)

---

## 🚀 Release Builds

### Android
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- Min SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)

### Windows
- Executable: `build/windows/runner/Release/notesecret.exe`
- Platform: Windows 10/11 (x64)
