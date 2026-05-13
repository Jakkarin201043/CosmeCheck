import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'data/ingredient_database.dart';
import 'data/mock_scan_history.dart';
import 'models/ingredient_confirmation_draft.dart';
import 'models/scan_result.dart';
import 'screens/allergy_profile_screen.dart';
import 'screens/confirm_ingredients_screen.dart';
import 'screens/education_article_screen.dart';
import 'screens/home_dashboard_screen.dart';
import 'screens/ingredient_detail_screen.dart';
import 'screens/ingredient_search_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/patch_test_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/saved_products_screen.dart';
import 'screens/scan_camera_screen.dart';
import 'screens/scan_history_screen.dart';
import 'screens/scan_result_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/main_shell.dart';

class CosmeCheckApp extends StatelessWidget {
  const CosmeCheckApp({super.key});

  static final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        name: 'onboarding',
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            name: 'home',
            path: '/home',
            builder: (context, state) => const HomeDashboardScreen(),
          ),
          GoRoute(
            name: 'ingredients',
            path: '/ingredients',
            builder: (context, state) => const IngredientSearchScreen(),
          ),
          GoRoute(
            name: 'scan',
            path: '/scan',
            builder: (context, state) => const ScanCameraScreen(),
          ),
          GoRoute(
            name: 'saved',
            path: '/saved',
            builder: (context, state) => const SavedProductsScreen(),
          ),
          GoRoute(
            name: 'profile',
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        name: 'confirmIngredients',
        path: '/confirm-ingredients',
        builder: (context, state) {
          final draft = state.extra is IngredientConfirmationDraft
              ? state.extra! as IngredientConfirmationDraft
              : IngredientConfirmationDraft(
                  rawOcrText: MockScanHistory.items.first.ocrText,
                  parsedIngredients:
                      MockScanHistory.items.first.detectedIngredients,
                  productName: MockScanHistory.items.first.productName,
                );
          return ConfirmIngredientsScreen(draft: draft);
        },
      ),
      GoRoute(
        name: 'scanResult',
        path: '/scan-result',
        builder: (context, state) {
          final result = state.extra is ScanResult
              ? state.extra! as ScanResult
              : MockScanHistory.items.first;
          return ScanResultScreen(result: result);
        },
      ),
      GoRoute(
        name: 'allergyProfile',
        path: '/allergy-profile',
        builder: (context, state) => const AllergyProfileScreen(),
      ),
      GoRoute(
        name: 'ingredientDetail',
        path: '/ingredient-detail',
        builder: (context, state) {
          final id = state.uri.queryParameters['id'] ?? 'niacinamide';
          final ingredient = IngredientDatabase.findById(id);
          return IngredientDetailScreen(ingredient: ingredient);
        },
      ),
      GoRoute(
        name: 'patchTest',
        path: '/patch-test',
        builder: (context, state) => const PatchTestScreen(),
      ),
      GoRoute(
        name: 'education',
        path: '/education',
        builder: (context, state) => const EducationArticleScreen(),
      ),
      GoRoute(
        name: 'history',
        path: '/history',
        builder: (context, state) => const ScanHistoryScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CosmeCheck',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
