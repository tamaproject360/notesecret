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

### 🔄 Phase 5: Organization & Search (In Progress)
- ✅ **Search Engine**: 
  - Full-text search with Isar indexing
  - Real-time search with 200ms debounce
  - Search screen with empty states
  - Search in note title and body (case-insensitive)
- 🔄 **Folder System**: Basic folder model created, UI pending
- ⏳ **Tagging System**: Pending

### 🐛 Bug Fixes
- Fixed Gradle build errors (core library desugaring, namespace conflicts)
- Fixed CardTheme/CardThemeData type compatibility
- Fixed splash screen navigation (auto-navigate to home after 1.5s)
- Updated flutter_local_notifications to v17.2.4 (resolved compilation errors)

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
