import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:privatusai/services/settings_service.dart';
import 'package:privatusai/services/conversation_storage_service.dart';
import 'package:provider/provider.dart';
import 'package:privatusai/l10n/app_localizations.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late TextEditingController _aiApiKeyController;
  late String _selectedAiServiceType;
  late String _selectedAiModel;
  late Color _lightPrimaryColor;
  late Color _lightAccentColor;
  late Color _darkPrimaryColor;
  late Color _darkAccentColor;
  late Locale _selectedLocale;

  final List<String> _aiServiceOptions = ['OpenAI', 'Gemini'];
  final ConversationStorageService _conversationStorageService = ConversationStorageService();

  String _licenseText = '';
  bool _licenseLoaded = false;

  @override
  void initState() {
    super.initState();
    final settingsService = Provider.of<SettingsService>(context, listen: false);
    _aiApiKeyController = TextEditingController(text: settingsService.aiApiKey ?? '');
    _selectedAiServiceType = settingsService.aiServiceType;
    _selectedAiModel = settingsService.aiModel;
    _lightPrimaryColor = settingsService.lightModePrimaryColor;
    _lightAccentColor = settingsService.lightModeAccentColor;
    _darkPrimaryColor = settingsService.darkModePrimaryColor;
    _darkAccentColor = settingsService.darkModeAccentColor;
    _selectedLocale = settingsService.locale;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_licenseLoaded) {
      _loadLicenseText();
      _licenseLoaded = true;
    }
  }

  @override
  void dispose() {
    _aiApiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadLicenseText() async {
    final localizations = AppLocalizations.of(context)!;
    try {
      final String text = await rootBundle.loadString('assets/LICENSE');
      setState(() {
        _licenseText = text;
      });
    } catch (e) {
      setState(() {
        _licenseText = localizations.failedToLoadLicense(e.toString());
      });
    }
  }

  void _pickColor(BuildContext context, Color currentColor, Function(Color) onColorChangedFunction) {
    final localizations = AppLocalizations.of(context)!;
    Color tempPickedColor = currentColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.chooseColorTitle),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempPickedColor,
              onColorChanged: (color) {
                setState(() => tempPickedColor = color);
                onColorChangedFunction(color);
              },
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.selectButton),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmAndDeleteAllConversations() async {
    final localizations = AppLocalizations.of(context)!;
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.deleteAllConversationsTitle),
          content: Text(localizations.deleteAllConversationsConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(localizations.cancelButton),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(localizations.deleteAllButton),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _conversationStorageService.saveConversations([]);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.allConversationsDeleted),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void _showLicenseDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.applicationLicenseTitle),
          content: SingleChildScrollView(
            child: Text(
              _licenseText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.closeButton),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsService = Provider.of<SettingsService>(context);
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          constraints: const BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Text(
                  localizations.settingsTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedAiServiceType,
                  decoration: InputDecoration(
                    labelText: localizations.aiServiceLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                  ),
                  items: _aiServiceOptions.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(
                        type,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedAiServiceType = newValue;
                        _selectedAiModel = settingsService.getModelsForService(newValue).first;
                      });
                      settingsService.setAiServiceType(newValue);
                    }
                  },
                  dropdownColor: theme.colorScheme.surface,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedAiModel,
                  decoration: InputDecoration(
                    labelText: localizations.aiModelLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                  ),
                  items: settingsService.getModelsForService(_selectedAiServiceType).map((String model) {
                    return DropdownMenuItem<String>(
                      value: model,
                      child: Text(
                        model,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedAiModel = newValue;
                      });
                      settingsService.setAiModel(newValue);
                    }
                  },
                  dropdownColor: theme.colorScheme.surface,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _aiApiKeyController,
                  decoration: InputDecoration(
                    labelText: localizations.aiApiKeyLabel,
                    hintText: localizations.aiApiKeyHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                  ),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  onChanged: (value) {
                    settingsService.setAiApiKey(value);
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  localizations.lightModeColorsTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickColor(context, _lightPrimaryColor, (color) {
                        setState(() => _lightPrimaryColor = color);
                        settingsService.setLightModeColors(_lightPrimaryColor, _lightAccentColor);
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _lightPrimaryColor,
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        localizations.primaryColorButton,
                        style: TextStyle(
                            color: _lightPrimaryColor.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _pickColor(context, _lightAccentColor, (color) {
                        setState(() => _lightAccentColor = color);
                        settingsService.setLightModeColors(_lightPrimaryColor, _lightAccentColor);
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _lightAccentColor,
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        localizations.accentColorButton,
                        style: TextStyle(
                            color: _lightAccentColor.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  localizations.darkModeColorsTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickColor(context, _darkPrimaryColor, (color) {
                        setState(() => _darkPrimaryColor = color);
                        settingsService.setDarkModeColors(_darkPrimaryColor, _darkAccentColor);
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _darkPrimaryColor,
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        localizations.primaryColorButton,
                        style: TextStyle(
                            color: _darkPrimaryColor.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _pickColor(context, _darkAccentColor, (color) {
                        setState(() => _darkAccentColor = color);
                        settingsService.setDarkModeColors(_darkPrimaryColor, _darkAccentColor);
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _darkAccentColor,
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        localizations.accentColorButton,
                        style: TextStyle(
                            color: _darkAccentColor.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<Locale>(
                  value: _selectedLocale,
                  decoration: InputDecoration(
                    labelText: localizations.languageLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: Locale('fr'),
                      child: Text('Français'),
                    ),
                  ],
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      setState(() {
                        _selectedLocale = newLocale;
                      });
                      settingsService.setLocale(newLocale);
                    }
                  },
                  dropdownColor: theme.colorScheme.surface,
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () => _showLicenseDialog(context),
                  icon: const Icon(Icons.description),
                  label: Text(localizations.showLicenseButton),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onPrimary,
                    backgroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _confirmAndDeleteAllConversations,
                  icon: const Icon(Icons.delete_forever),
                  label: Text(localizations.deleteAllConversationsButton),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}