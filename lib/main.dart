import 'package:e_health_system/features/chat/data/repositories/conversation_repository.dart';
import 'package:e_health_system/features/notification/data/repositories/local_notification_repository.dart';
import 'package:e_health_system/features/notification/domain/repositories/notification_repository.dart';
import 'package:e_health_system/features/blog/data/repositories/blog_repositories.dart';
import 'package:e_health_system/features/search/data/repositories/doctor_repository.dart';
import 'package:e_health_system/features/search/presentation/bloc/search_bloc.dart';
import 'package:e_health_system/features/search/presentation/blocs/doctor_bloc.dart';
import 'package:e_health_system/features/home/presentation/bloc/speciality_bloc.dart';
import 'package:e_health_system/features/home/data/repositories/local_specialtity_repository.dart';
import 'package:e_health_system/features/auth/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ConversationRepository>(
          create: (_) => ConversationRepository(),
        ),
        RepositoryProvider<NotificationRepository>(
          create: (_) => LocalNotificationRepository(),
        ),
        RepositoryProvider<BlogRepository>(
          create: (_) => BlogRepository(),
        ),
        RepositoryProvider<DoctorRepository>(
          create: (_) => DoctorRepository(),
        ),
        RepositoryProvider<LocalSpecialityRepository>(
          create: (_) => LocalSpecialityRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(
              blogRepository: context.read<BlogRepository>(),
              doctorRepository: context.read<DoctorRepository>(),
            ),
          ),
          BlocProvider<DoctorBloc>(
            create: (context) => DoctorBloc(
              doctorRepository: context.read<DoctorRepository>(),
            ),
          ),
          BlocProvider<SpecialityBloc>(
            create: (context) => SpecialityBloc(
              specialityRepository: context.read<LocalSpecialityRepository>(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      routerDelegate: appRouter.routerDelegate,
      routeInformationParser: appRouter.routeInformationParser,
      routeInformationProvider: appRouter.routeInformationProvider,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
