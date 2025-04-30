import 'package:e_health_system/features/appointment/presentation/screens/appointment_screen.dart';
import 'package:e_health_system/features/auth/Presentation/screens/login_screen.dart';
import 'package:e_health_system/features/auth/Presentation/screens/role_selection_screen.dart';
import 'package:e_health_system/features/blog/presentation/screens/blog_screen.dart';
import 'package:e_health_system/features/chat/presentation/screens/chat_conversation_screen.dart';
import 'package:e_health_system/features/chat/presentation/screens/chat_screen.dart';
import 'package:e_health_system/features/home/presentation/screens/drawer/about_us_screen.dart';
import 'package:e_health_system/features/home/presentation/screens/drawer/faq_screen.dart';
import 'package:e_health_system/features/settings/presentation/screens/setting_screen.dart';
import 'package:e_health_system/globals.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/Presentation/screens/sign_up_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/widgets/persistent_bottom_nav_scaffold.dart';
import '../../features/notification/presentation/notification_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // --- Authentication Routes (outside the persistent shell) ---
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
      const RoleSelectionScreen(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (BuildContext context, GoRouterState state) =>
          const LoginScreen(),
        ),
        GoRoute(
          path: 'sign-up',
          builder: (BuildContext context, GoRouterState state) =>
          const SignUpScreen(),
        ),
      ],
    ),
    // --- Main App Routes with Persistent Bottom Navigation ---
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return PersistentBottomNavScaffold(child: child);
      },
      routes: [
        // Home
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) =>
          const HomeScreen(),
        ),
        // Appointments
        GoRoute(
          path: '/appointments',
          builder: (BuildContext context, GoRouterState state) =>
          const AppointmentScreen(),
        ),
        // Chat (main chat screen)
        GoRoute(
          path: '/chat',
          builder: (BuildContext context, GoRouterState state) =>  const ChatScreen(),
        ),
        // Blog
        GoRoute(
          path: '/blog',
          builder: (BuildContext context, GoRouterState state) {
            return BlogScreen(isDoctor: isDoctorUser);
          },
        ),
      ],
    ),
    // --- Global Routes (outside of ShellRoute) ---
    // Profile
    GoRoute(
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) =>
          ProfileScreen(isDoctor: isDoctorUser,),
    ),
    // Settings
    GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) =>
      const SettingsScreen(),
    ),
    // Notifications
    GoRoute(
      path: '/notifications',
      builder: (BuildContext context, GoRouterState state) =>
      NotificationScreen(isDoctor: isDoctorUser,),
    ),
    // Global Chat Conversation Route (covers the whole page)
    GoRoute(
      path: '/conversation',
      builder: (BuildContext context, GoRouterState state) {
        // final String id = state.pathParameters['id']!;
        return const ChatConversationScreen();
      },
    ),
    // About us
    GoRoute(
      path: '/about-us',
      builder: (BuildContext context, GoRouterState state) =>
         const  AboutUsScreen()
    ),
    // faq
    GoRoute(
      path: '/faq',
      builder: (BuildContext context, GoRouterState state) =>
          const FAQScreen(),
    ),
  ],
  errorBuilder: (BuildContext context, GoRouterState state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Text(state.error.toString()),
    ),
  ),
);
