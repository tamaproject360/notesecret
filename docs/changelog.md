# Changelog - NoteSecret

## [Unreleased] - 2025-02-15

### ✅ Phase 1-3: Foundation & Core Features (Completed)
- **Project Setup**: Flutter project initialized with strict typing and git repository
- **Dependencies**: All core packages added (Riverpod, Isar, Google Fonts, Lucide Icons, etc.)
- **Theming**: Light/Dark mode with Parchment White and Warm Black color schemes
- **Routing**: GoRouter implementation with bottom navigation
- **Database**: Isar NoSQL database with Note, Folder models
- **UI Components**: 
  - Reusable widgets (Buttons, Input Fields, Note Cards, Skeleton Loaders)
  - Bottom Navigation Bar with active/inactive states
  - Feedback systems (Snackbar, BottomSheet)
- **Notes Management**:
  - Home Dashboard with Grid/List toggle
  - Note Editor with auto-save (2s debounce)
  - CRUD operations (Create, Read, Update, Soft Delete)
  - Pinned notes section
  - Empty states with illustrations

### 🔄 Phase 4: Security & Privacy (In Progress)
- ✅ **Biometrics & PIN**: Implemented `local_auth` for fingerprint/face authentication
- ✅ **Vault Feature**: Locked notes accessible only via biometric/PIN
- ✅ **Auto-Lock**: App lifecycle observer for automatic vault locking on background (30s timeout)
- ✅ **Auth Service**: Complete PIN management with flutter_secure_storage

### 🔄 Phase 5: Organization & Search (Completed ✅)
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
- ⏳ **Tagging System**: Pending

### ✅ Phase 6: Data Management & Settings (80% Complete)
- ✅ **Settings UI**: 
  - Comprehensive settings screen with sections
  - Security: PIN management, Biometric toggle
  - Data: Link to Trash
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
- ✅ **Backup & Restore Service**: 
  - AES-256 encrypted backup generation
  - Create .notesecret backup files
  - Password-protected encryption
  - Restore from encrypted backup
  - Parse notes and folders from backup
  - Share backup via system share sheet
  - Service: `backup_service.dart`
- ⏳ **Notifications**: Pending

### ✅ Phase 7: Onboarding & Polish (50% Complete)
- ✅ **Onboarding Flow**: 
  - 4-screen PageView with smooth transitions
  - Welcome, Offline First, Lock, Start Writing screens
  - Skip button functionality
  - Animated dot indicators
  - Get Started CTA
  - Beautiful illustrations with Lucide icons
  - `onboarding_screen.dart`
- ✅ **Splash Screen**: Auto-navigate with branding
- ⏳ **Motion Polish**: Pending
- ⏳ **QA Checklist**: Pending

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

### 📝 Documentation
- Created `docs/specs.md` with comprehensive project guidelines
- Updated `docs/task.md` with progress tracking
- Maintained consistent commit history

### 🔧 Technical Improvements
- Android build configuration optimized (AGP 8+, Java 17)
- Code generation setup (Riverpod, Isar, Freezed)
- Proper error handling and state management
- Material 3 design system implementation

---

## Next Steps (Phase 6-7)
- [ ] Settings UI with sections (Appearance, Security, Backup)
- [ ] Trash/Bin with 30-day auto-purge
- [ ] Export to PDF, Markdown, Plain text
- [ ] AES-256 encrypted backup & restore
- [ ] Onboarding flow (4-screen intro)
- [ ] Local notifications for reminders
- [ ] QA & Polish (touch targets, animations, accessibility)
