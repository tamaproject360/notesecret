# Development Task List - NoteSecret

## Overview
This document outlines the comprehensive development roadmap for **NoteSecret**, a privacy-first, offline-only note-taking application, based on the specifications in `docs/design-system.xml`.

| No | Task | Status | Priority | Phase |
|----|------|--------|----------|-------|
| **1** | **Phase 1: Foundation & Architecture** | | | |
| 1.1 | **Project Setup**: Initialize Flutter project, configure `analysis_options.yaml` for strict typing, and set up git repository structure. | ✅ Completed | High | Phase 1 |
| 1.2 | **Dependencies**: Add core packages (`flutter_riverpod`, `isar`, `path_provider`, `google_fonts`, `lucide_icons`, `intl`, `flutter_svg`). | ✅ Completed | High | Phase 1 |
| 1.3 | **Asset Management**: Configure `pubspec.yaml` for fonts (Lora, Merriweather, Inter, JetBrains Mono) and assets/icons. | ✅ Completed | High | Phase 1 |
| 1.4 | **Theming Engine**: Implement `AppTheme` class with Light (Parchment White) and Dark (Warm Black) modes, defining custom `TextTheme` and `ColorScheme` as per XML specs. | ✅ Completed | High | Phase 1 |
| 1.5 | **Routing**: Set up `GoRouter` or `AutoRoute` for navigation handling (Home, Editor, Vault, Settings, Onboarding). | ✅ Completed | High | Phase 1 |
| 1.6 | **Local Database Setup**: Initialize **Isar** database schemas for `Note`, `Folder`, `Tag`, and `Settings`. | ✅ Completed | High | Phase 1 |
| 1.7 | **State Management**: Set up basic Riverpod providers for Theme, Database, and Auth state. | ✅ Completed | High | Phase 1 |
| **2** | **Phase 2: Core UI Components (Design System)** | | | |
| 2.1 | **Base Widgets**: Create reusable atoms: `PrimaryButton` (Sage Green), `GhostButton`, `InputTextField` (Floating label), `NoteCard` (with color strips). | ✅ Completed | High | Phase 2 |
| 2.2 | **Navigation Bar**: Implement the custom Bottom Tab Bar (Home, Vault, Folders, Settings) with active/inactive states and animations. | ✅ Completed | High | Phase 2 |
| 2.3 | **Feedback Systems**: Implement custom `Snackbar` (Toast) and `BottomSheet` modal components (slide-up animations, custom styling). | ✅ Completed | Medium | Phase 2 |
| 2.4 | **Skeleton Loaders**: Create shimmer loading effects for notes list and search results (No spinners allowed). | ✅ Completed | Medium | Phase 2 |
| **3** | **Phase 3: Core Features - Notes Management** | | | |
| 3.1 | **Home Dashboard**: Build Grid/List toggle view with `SliverGrid`/`SliverList`. Implement "Pinned" section and Empty State illustrations. | ✅ Completed | High | Phase 3 |
| 3.2 | **Note Editor UI**: Build distraction-free editor with Title input, Body input, and custom Formatting Toolbar (Keyboard accessory view). | ✅ Completed | High | Phase 3 |
| 3.3 | **Editor Logic**: Implement specific editor features: Auto-save (2s debounce), Markdown toggling, and Word/Character count. | ✅ Completed | High | Phase 3 |
| 3.4 | **CRUD Operations**: Implement Create, Read, Update, Soft Delete logic using Isar repositories. | ✅ Completed | High | Phase 3 |
| 3.5 | **Attachments**: Implement image picking (`image_picker`) and local caching for adding images to notes. | Pending | Medium | Phase 3 |
| **4** | **Phase 4: Security & Privacy (The "Secret" Aspect)** | | | |
| 4.1 | **Biometrics & PIN**: Implement `local_auth` for Fingerprint/Face ID and `flutter_secure_storage` for PIN management. | ✅ Completed | High | Phase 4 |
| 4.2 | **Vault Feature**: Create the "Vault" screen (accessible only via auth), handling locking/unlocking logic for individual notes. | ✅ Completed | High | Phase 4 |
| 4.3 | **Auto-Lock**: Implement app lifecycle listening to auto-lock Vault on background/inactive state (30s timeout). | ✅ Completed | High | Phase 4 |
| **5** | **Phase 5: Organization & Search** | | | |
| 5.1 | **Folder System**: Build Folder creation/management UI with Emoji picker and drag-and-drop reordering. | ✅ Completed | Medium | Phase 5 |
| 5.2 | **Tagging System**: Implement Tag creation, assignment to notes, and filtering logic. | Pending | Medium | Phase 5 |
| 5.3 | **Search Engine**: Implement Full-text search (Isar indexed) with real-time highlighting and 200ms debounce. | ✅ Completed | High | Phase 5 |
| **6** | **Phase 6: Data Management & Settings** | | | |
| 6.1 | **Settings UI**: Build the Settings screen with sections: Appearance, Security, Notes, Backup, Data, About. | ✅ Completed | Low | Phase 6 |
| 6.2 | **Trash / Bin**: Implement Trash screen with "Restore" and "Delete Permanently" (plus 30-day auto-purge logic). | ✅ Completed | Medium | Phase 6 |
| 6.3 | **Export**: Implement Note export to PDF (`pdf` package), Markdown, and Plain text. | ✅ Completed | Medium | Phase 6 |
| 6.4 | **Backup & Restore**: Implement AES-256 encrypted JSON backup generation (`.notesecret` file) and restore logic. | ✅ Completed | High | Phase 6 |
| 6.5 | **Notifications**: Implement local reminders using `flutter_local_notifications`. | Pending | Low | Phase 6 |
| **7** | **Phase 7: Onboarding & Polish** | | | |
| 7.1 | **Onboarding Flow**: Build the 4-screen intro sequence (Welcome, Offline First, Lock, Get Started) with "Skip" logic. | ✅ Completed | Low | Phase 7 |
| 7.2 | **Splash Screen**: Create the native splash screen and the Flutter implementation with fade-out transition. | ✅ Completed | Low | Phase 7 |
| 7.3 | **Motion Polish**: Audit all animations (150ms transitions, 0.97 scale on buttons) to match "Snappy" philosophy. | Pending | Medium | Phase 7 |
| 7.4 | **QA Checklist**: Verify touch targets (44px+), contrast ratios, and offline functionality. | Pending | High | Phase 7 |

## Notes
- **Tech Stack**: Flutter 3.x, Riverpod, Isar (NoSQL), Local Auth, AES-256 Encryption.
- **Philosophy**: "Calm Technology" - No Friction, Content-First, Thumb-Zone Architecture.
- **Design**: Strict adherence to the Color System (Sage Green Accent) and Typography (Lora/Merriweather).
