import 'package:flutter/material.dart';
import 'package:privatusai/pages/home_page.dart';
import 'package:privatusai/services/settings_service.dart';
import 'package:privatusai/widgets/settings_dialog.dart';
import 'package:provider/provider.dart';
import 'package:privatusai/l10n/app_localizations.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final bool showHomeButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.showHomeButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsService = Provider.of<SettingsService>(context);
    final localizations = AppLocalizations.of(context)!;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      centerTitle: false,
      actions: [
        if (showHomeButton)
          IconButton(
            icon: Icon(Icons.home, color: theme.colorScheme.onBackground),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                    (Route<dynamic> route) => false,
              );
            },
            tooltip: localizations.homeButtonTooltip,
          ),
        IconButton(
          icon: Icon(
            settingsService.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode,
            color: theme.colorScheme.onBackground,
          ),
          onPressed: () {
            settingsService.toggleThemeMode();
          },
          tooltip: settingsService.themeMode == ThemeMode.dark
              ? localizations.switchToLightModeTooltip
              : localizations.switchToDarkModeTooltip,
        ),
        IconButton(
          icon: Icon(Icons.settings, color: theme.colorScheme.onBackground),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const SettingsDialog(),
            );
          },
          tooltip: localizations.settingsButtonTooltip,
        ),
      ],
    );
  }
}