import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:privatusai/pages/conversation_page.dart';
import 'package:privatusai/widgets/custom_app_bar.dart';
import 'package:privatusai/services/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:privatusai/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsService = Provider.of<SettingsService>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    final Color backgroundColor = isDarkMode
        ? settingsService.darkModePrimaryColor.withOpacity(0.7)
        : settingsService.lightModePrimaryColor.withOpacity(0.7);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: localizations.privatusaiTitle, showHomeButton: false),
      body: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: backgroundColor,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'PrivatusAI',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        localizations.welcomeMessage,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConversationPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat),
                    label: Text(localizations.goToConversationsButton),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme.colorScheme.onPrimary,
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConversationPage(
                            conversationId: UniqueKey().toString(),
                            conversationTitle: localizations.newConversationTitle,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_comment),
                    label: Text(localizations.startNewConversationButton),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme.colorScheme.onPrimary,
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}