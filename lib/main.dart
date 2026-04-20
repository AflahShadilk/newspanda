import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newspanda/features/presentation/bloc/news_bloc.dart';
import 'package:newspanda/features/presentation/pages/news_list_page.dart';
import 'package:newspanda/id/dependency_injection.dart';
import 'core/theme/app_theme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppTheme.bgPrimary,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize dependency injection
  await init();

  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewsBloc>(),
      child: MaterialApp(
        title: 'News Reader',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const NewsListPage(),
      ),
    );
  }
}