import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notesecret/features/notes/notes_list_screen.dart';
import 'package:notesecret/features/notes/note_editor_screen.dart';
import 'package:notesecret/features/notes/search_screen.dart';
import 'package:notesecret/features/settings/settings_screen.dart';
import 'package:notesecret/features/vault/vault_screen.dart';
import 'package:notesecret/features/folders/folders_screen.dart';
import 'package:notesecret/features/onboarding/onboarding_screen.dart';
import 'package:notesecret/features/splash/splash_screen.dart';
import 'package:notesecret/shared/widgets/bottom_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/note/:id',
      parentNavigatorKey: _rootNavigatorKey, // Hide bottom nav
      builder: (context, state) {
        final idStr = state.pathParameters['id'];
        final id = idStr == 'new' ? null : int.tryParse(idStr ?? '');
        return NoteEditorScreen(noteId: id);
      },
    ),
    GoRoute(
      path: '/search',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SearchScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const NotesListScreen(),
        ),
        GoRoute(
          path: '/vault',
          builder: (context, state) => const VaultScreen(),
        ),
        GoRoute(
          path: '/folders',
          builder: (context, state) => const FoldersScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
