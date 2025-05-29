import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @privatusaiTitle.
  ///
  /// In en, this message translates to:
  /// **'PrivatusAI'**
  String get privatusaiTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to PrivatusAI, your confidential and open-source AI assistant.\n\n**Latest Updates:**\n- New user interface for a better experience.\n- Ability to customize theme colors.\n- Support for integrating your own AI API key.\n- Improved conversation management (move, delete, rename).\n\nStart a new conversation or pick up where you left off!'**
  String get welcomeMessage;

  /// No description provided for @goToConversationsButton.
  ///
  /// In en, this message translates to:
  /// **'Go to Conversations'**
  String get goToConversationsButton;

  /// No description provided for @startNewConversationButton.
  ///
  /// In en, this message translates to:
  /// **'Start a New Conversation'**
  String get startNewConversationButton;

  /// No description provided for @aiApiKeyNotSet.
  ///
  /// In en, this message translates to:
  /// **'Please set your AI API key in settings.'**
  String get aiApiKeyNotSet;

  /// No description provided for @aiErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'PrivatusAI: Error'**
  String get aiErrorPrefix;

  /// No description provided for @newConversationTitle.
  ///
  /// In en, this message translates to:
  /// **'New Conversation'**
  String get newConversationTitle;

  /// No description provided for @renameConversationTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Conversation'**
  String get renameConversationTitle;

  /// No description provided for @newTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'New Title'**
  String get newTitleLabel;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @renameButton.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameButton;

  /// No description provided for @deleteConversationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Conversation?'**
  String get deleteConversationTitle;

  /// No description provided for @deleteConversationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{conversationTitle}\"?'**
  String deleteConversationConfirm(Object conversationTitle);

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @messageCopied.
  ///
  /// In en, this message translates to:
  /// **'Message copied!'**
  String get messageCopied;

  /// No description provided for @copyMessageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy message'**
  String get copyMessageTooltip;

  /// No description provided for @selectPromptTooltip.
  ///
  /// In en, this message translates to:
  /// **'Select a prompt'**
  String get selectPromptTooltip;

  /// No description provided for @sendMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Send a message...'**
  String get sendMessageHint;

  /// No description provided for @conversationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversations'**
  String get conversationsTitle;

  /// No description provided for @newConversationButton.
  ///
  /// In en, this message translates to:
  /// **'New Conversation'**
  String get newConversationButton;

  /// No description provided for @managePromptsTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Prompts'**
  String get managePromptsTitle;

  /// No description provided for @editPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Prompt'**
  String get editPromptTitle;

  /// No description provided for @promptContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Prompt content'**
  String get promptContentLabel;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @addNewPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Prompt'**
  String get addNewPromptTitle;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @addNewPromptButton.
  ///
  /// In en, this message translates to:
  /// **'Add New Prompt'**
  String get addNewPromptButton;

  /// No description provided for @startChattingPrompt.
  ///
  /// In en, this message translates to:
  /// **'Start chatting with PrivatusAI!'**
  String get startChattingPrompt;

  /// No description provided for @homeButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get homeButtonTooltip;

  /// No description provided for @menuButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open conversations'**
  String get menuButtonTooltip;

  /// No description provided for @switchToLightModeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Switch to Light Mode'**
  String get switchToLightModeTooltip;

  /// No description provided for @switchToDarkModeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Switch to Dark Mode'**
  String get switchToDarkModeTooltip;

  /// No description provided for @settingsButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsButtonTooltip;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @aiServiceLabel.
  ///
  /// In en, this message translates to:
  /// **'AI Service'**
  String get aiServiceLabel;

  /// No description provided for @aiModelLabel.
  ///
  /// In en, this message translates to:
  /// **'AI Model'**
  String get aiModelLabel;

  /// No description provided for @aiApiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'AI API Key'**
  String get aiApiKeyLabel;

  /// No description provided for @aiApiKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your API key here'**
  String get aiApiKeyHint;

  /// No description provided for @lightModeColorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Light Mode Colors'**
  String get lightModeColorsTitle;

  /// No description provided for @primaryColorButton.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primaryColorButton;

  /// No description provided for @accentColorButton.
  ///
  /// In en, this message translates to:
  /// **'Accent'**
  String get accentColorButton;

  /// No description provided for @darkModeColorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode Colors'**
  String get darkModeColorsTitle;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @showLicenseButton.
  ///
  /// In en, this message translates to:
  /// **'Show License'**
  String get showLicenseButton;

  /// No description provided for @deleteAllConversationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete All Conversations?'**
  String get deleteAllConversationsTitle;

  /// No description provided for @deleteAllConversationsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all your conversations? This action is irreversible.'**
  String get deleteAllConversationsConfirm;

  /// No description provided for @deleteAllButton.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAllButton;

  /// No description provided for @deleteAllConversationsButton.
  ///
  /// In en, this message translates to:
  /// **'Delete All Conversations'**
  String get deleteAllConversationsButton;

  /// No description provided for @allConversationsDeleted.
  ///
  /// In en, this message translates to:
  /// **'All conversations deleted.'**
  String get allConversationsDeleted;

  /// No description provided for @applicationLicenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Application License'**
  String get applicationLicenseTitle;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @chooseColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a color'**
  String get chooseColorTitle;

  /// No description provided for @selectButton.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectButton;

  /// No description provided for @failedToLoadLicense.
  ///
  /// In en, this message translates to:
  /// **'Failed to load license: {error}'**
  String failedToLoadLicense(Object error);

  /// No description provided for @errorLoadingLicense.
  ///
  /// In en, this message translates to:
  /// **'Error loading license'**
  String get errorLoadingLicense;

  /// No description provided for @apiKeyNotSetError.
  ///
  /// In en, this message translates to:
  /// **'API Key not set. Please go to settings to set your AI API key.'**
  String get apiKeyNotSetError;

  /// No description provided for @unsupportedAIServiceType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported AI service type: {serviceType}'**
  String unsupportedAIServiceType(Object serviceType);

  /// No description provided for @geminiResponseNotFound.
  ///
  /// In en, this message translates to:
  /// **'Gemini response content not found or empty.'**
  String get geminiResponseNotFound;

  /// No description provided for @noContentFound.
  ///
  /// In en, this message translates to:
  /// **'No content found for this AI service type.'**
  String get noContentFound;

  /// No description provided for @failedToLoadAIResponse.
  ///
  /// In en, this message translates to:
  /// **'Failed to load AI response'**
  String get failedToLoadAIResponse;

  /// No description provided for @errorCommunicatingWithAI.
  ///
  /// In en, this message translates to:
  /// **'Error communicating with AI'**
  String get errorCommunicatingWithAI;

  /// No description provided for @openAISystemPrompt.
  ///
  /// In en, this message translates to:
  /// **'You are PrivatusAI, an assistant developed by PrivatusAI. Never say you were created by Google or any similar entity. Always respond as PrivatusAI.'**
  String get openAISystemPrompt;

  /// No description provided for @openAIAssistantResponse.
  ///
  /// In en, this message translates to:
  /// **'Of course, I am PrivatusAI, developed by PrivatusAI. How can I assist you?'**
  String get openAIAssistantResponse;

  /// No description provided for @geminiSystemPrompt.
  ///
  /// In en, this message translates to:
  /// **'You are PrivatusAI, an assistant developed by PrivatusAI. Never say you were created by Google or any similar entity. Always respond as PrivatusAI.'**
  String get geminiSystemPrompt;

  /// No description provided for @geminiAssistantResponse.
  ///
  /// In en, this message translates to:
  /// **'Of course, I am PrivatusAI, developed by PrivatusAI. How can I assist you?'**
  String get geminiAssistantResponse;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
