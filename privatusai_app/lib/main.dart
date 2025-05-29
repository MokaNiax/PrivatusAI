import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:privatusai/pages/home_page.dart';
import 'package:privatusai/services/settings_service.dart';
import 'package:privatusai/services/conversation_storage_service.dart';
import 'package:privatusai/theme/app_theme.dart';
import 'package:privatusai/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsService = SettingsService();
  await settingsService.loadSettings();

  final conversationStorageService = ConversationStorageService();
  final initialConversations = await conversationStorageService.loadConversations();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => settingsService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsService = Provider.of<SettingsService>(context);

    return MaterialApp(
      title: 'PrivatusAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(
        settingsService.lightModePrimaryColor,
        settingsService.lightModeAccentColor,
      ),
      darkTheme: AppTheme.darkTheme(
        settingsService.darkModePrimaryColor,
        settingsService.darkModeAccentColor,
      ),
      themeMode: settingsService.themeMode,
      locale: settingsService.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomePage(),
    );
  }
}