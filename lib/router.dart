import 'package:flubriry/models/component_catalog.dart';
import 'package:flubriry/views/component/component_detail_page.dart';
import 'package:flubriry/views/contribute/contribute_page.dart';
import 'package:flubriry/views/library/library_page.dart';
import 'package:flubriry/views/not_found_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const LibraryPage(),
        ),
      ),
      GoRoute(
        path: '/contribute',
        pageBuilder: (context, state) =>
            _fadePage(key: state.pageKey, child: const ContributePage()),
      ),
      GoRoute(
        path: '/component/:id',
        redirect: (context, state) {
          final id = state.pathParameters['id'];
          return ComponentCatalog.byId(id ?? '') == null ? '/' : null;
        },
        pageBuilder: (context, state) {
          final entry = ComponentCatalog.byId(
            state.pathParameters['id'] ?? '',
          )!;
          return _fadePage(
            key: state.pageKey,
            child: ComponentDetailPage(entry: entry),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}

CustomTransitionPage<void> _fadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondary, child) {
      if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
        return child;
      }
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.02),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
