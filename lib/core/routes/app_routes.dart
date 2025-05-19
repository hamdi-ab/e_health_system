import 'package:e_health_system/features/appointment/presentation/screens/appointment_screen.dart';
import 'package:e_health_system/features/auth/Presentation/screens/login_screen.dart';
import 'package:e_health_system/features/auth/Presentation/screens/role_selection_screen.dart';
import 'package:e_health_system/features/auth/data/repositories/user_repository.dart';
import 'package:e_health_system/features/blog/presentation/screens/blog_screen.dart';
import 'package:e_health_system/features/chat/data/repositories/conversation_repository.dart';
import 'package:e_health_system/features/chat/presentation/blocs/conversation_bloc.dart';
import 'package:e_health_system/features/chat/presentation/blocs/conversation_event.dart';
import 'package:e_health_system/features/chat/presentation/screens/chat_conversation_screen.dart';
import 'package:e_health_system/features/chat/presentation/screens/chat_screen.dart';
import 'package:e_health_system/features/home/presentation/screens/drawer/about_us_screen.dart';
import 'package:e_health_system/features/home/presentation/screens/drawer/faq_screen.dart';
import 'package:e_health_system/features/home/presentation/screens/specialty_doctors_screen.dart';
import 'package:e_health_system/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:e_health_system/features/profile/presentation/bloc/profile_event.dart';
import 'package:e_health_system/features/settings/presentation/screens/setting_screen.dart';
import 'package:e_health_system/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/Presentation/screens/sign_up_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/widgets/persistent_bottom_nav_scaffold.dart';
import '../../features/notification/presentation/notification_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

// Map of specialty IDs to their corresponding icons
final Map<String, IconData> specialtyIcons = {
  'sp1': Icons.favorite_rounded, // Cardiology
  'sp2': Icons.child_care, // Pediatrics
  'sp3': Icons.spa, // Dermatology
  'sp4': Icons.psychology, // Neurology
  'sp5': Icons.accessibility_new, // Orthopedics
  'sp6': Icons.local_hospital, // Oncology
  'sp7': Icons.pregnant_woman, // Gynecology
};

// Map of specialty IDs to their names
final Map<String, String> specialtyNames = {
  'sp1': 'Cardiology',
  'sp2': 'Pediatrics',
  'sp3': 'Dermatology',
  'sp4': 'Neurology',
  'sp5': 'Orthopedics',
  'sp6': 'Oncology',
  'sp7': 'Gynecology',
};

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
          builder: (BuildContext context, GoRouterState state) =>
              const ChatScreen(),
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
    // Specialty Doctors
    GoRoute(
      path: '/specialty/:id',
      builder: (BuildContext context, GoRouterState state) {
        final specialtyId = state.pathParameters['id']!;
        final specialtyName = specialtyNames[specialtyId] ?? 'Specialty';
        final specialtyIcon =
            specialtyIcons[specialtyId] ?? Icons.medical_services;

        return SpecialtyDoctorsScreen(
          specialtyId: specialtyId,
          specialtyName: specialtyName,
          specialtyIcon: specialtyIcon,
        );
      },
    ),
    // Profile
    GoRoute(
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) => BlocProvider(
        create: (context) => ProfileBloc(
          repository: RepositoryProvider.of<UserRepository>(context),
        )..add(LoadProfile()),
        child: ProfileScreen(
          isDoctor: isDoctorUser,
        ),
      ),
    ),
    // Settings
    GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) =>
          const SettingsScreen(),
    ),
    // Notifications
    GoRoute(
        path: '/notifications/:id',
        builder: (BuildContext context, GoRouterState state) {
          final UserId = state.pathParameters['id']!;
          return NotificationScreen(
            isDoctor: isDoctorUser,
            userId: UserId,
          );
        }),
    // Global Chat Conversation Route (covers the whole page)
    GoRoute(
      path: '/conversation/:id',
      builder: (BuildContext context, GoRouterState state) {
        final conversationId = state.pathParameters['id']!;
        return BlocProvider(
          create: (context) => ConversationBloc(
            repository: RepositoryProvider.of<ConversationRepository>(context),
          )..add(LoadConversation(conversationId)),
          child: ChatConversationScreen(conversationId: conversationId),
        );
      },
    ),
    // About us
    GoRoute(
        path: '/about-us',
        builder: (BuildContext context, GoRouterState state) =>
            const AboutUsScreen()),
    // faq
    GoRoute(
      path: '/faq',
      builder: (BuildContext context, GoRouterState state) => const FAQScreen(),
    ),
  ],
  errorBuilder: (BuildContext context, GoRouterState state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Text(state.error.toString()),
    ),
  ),
);
