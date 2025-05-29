// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get privatusaiTitle => 'PrivatusAI';

  @override
  String get welcomeMessage =>
      'Welcome to PrivatusAI, your confidential and open-source AI assistant.\n\n**Latest Updates:**\n- New user interface for a better experience.\n- Ability to customize theme colors.\n- Support for integrating your own AI API key.\n- Improved conversation management (move, delete, rename).\n\nStart a new conversation or pick up where you left off!';

  @override
  String get goToConversationsButton => 'Go to Conversations';

  @override
  String get startNewConversationButton => 'Start a New Conversation';

  @override
  String get aiApiKeyNotSet => 'Please set your AI API key in settings.';

  @override
  String get aiErrorPrefix => 'PrivatusAI: Error';

  @override
  String get newConversationTitle => 'New Conversation';

  @override
  String get renameConversationTitle => 'Rename Conversation';

  @override
  String get newTitleLabel => 'New Title';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get renameButton => 'Rename';

  @override
  String get deleteConversationTitle => 'Delete Conversation?';

  @override
  String deleteConversationConfirm(Object conversationTitle) {
    return 'Are you sure you want to delete \"$conversationTitle\"?';
  }

  @override
  String get deleteButton => 'Delete';

  @override
  String get messageCopied => 'Message copied!';

  @override
  String get copyMessageTooltip => 'Copy message';

  @override
  String get selectPromptTooltip => 'Select a prompt';

  @override
  String get sendMessageHint => 'Send a message...';

  @override
  String get conversationsTitle => 'Conversations';

  @override
  String get newConversationButton => 'New Conversation';

  @override
  String get managePromptsTitle => 'Manage Prompts';

  @override
  String get editPromptTitle => 'Edit Prompt';

  @override
  String get promptContentLabel => 'Prompt content';

  @override
  String get saveButton => 'Save';

  @override
  String get addNewPromptTitle => 'Add New Prompt';

  @override
  String get addButton => 'Add';

  @override
  String get addNewPromptButton => 'Add New Prompt';

  @override
  String get startChattingPrompt => 'Start chatting with PrivatusAI!';

  @override
  String get homeButtonTooltip => 'Go to Home';

  @override
  String get menuButtonTooltip => 'Open conversations';

  @override
  String get switchToLightModeTooltip => 'Switch to Light Mode';

  @override
  String get switchToDarkModeTooltip => 'Switch to Dark Mode';

  @override
  String get settingsButtonTooltip => 'Settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get aiServiceLabel => 'AI Service';

  @override
  String get aiModelLabel => 'AI Model';

  @override
  String get aiApiKeyLabel => 'AI API Key';

  @override
  String get aiApiKeyHint => 'Enter your API key here';

  @override
  String get lightModeColorsTitle => 'Light Mode Colors';

  @override
  String get primaryColorButton => 'Primary';

  @override
  String get accentColorButton => 'Accent';

  @override
  String get darkModeColorsTitle => 'Dark Mode Colors';

  @override
  String get languageLabel => 'Language';

  @override
  String get showLicenseButton => 'Show License';

  @override
  String get deleteAllConversationsTitle => 'Delete All Conversations?';

  @override
  String get deleteAllConversationsConfirm =>
      'Are you sure you want to delete all your conversations? This action is irreversible.';

  @override
  String get deleteAllButton => 'Delete All';

  @override
  String get deleteAllConversationsButton => 'Delete All Conversations';

  @override
  String get allConversationsDeleted => 'All conversations deleted.';

  @override
  String get applicationLicenseTitle => 'Application License';

  @override
  String get closeButton => 'Close';

  @override
  String get chooseColorTitle => 'Choose a color';

  @override
  String get selectButton => 'Select';

  @override
  String failedToLoadLicense(Object error) {
    return 'Failed to load license: $error';
  }

  @override
  String get errorLoadingLicense => 'Error loading license';

  @override
  String get apiKeyNotSetError =>
      'API Key not set. Please go to settings to set your AI API key.';

  @override
  String unsupportedAIServiceType(Object serviceType) {
    return 'Unsupported AI service type: $serviceType';
  }

  @override
  String get geminiResponseNotFound =>
      'Gemini response content not found or empty.';

  @override
  String get noContentFound => 'No content found for this AI service type.';

  @override
  String get failedToLoadAIResponse => 'Failed to load AI response';

  @override
  String get errorCommunicatingWithAI => 'Error communicating with AI';

  @override
  String get openAISystemPrompt =>
      'You are PrivatusAI, an assistant developed by PrivatusAI. Never say you were created by Google or any similar entity. Always respond as PrivatusAI.';

  @override
  String get openAIAssistantResponse =>
      'Of course, I am PrivatusAI, developed by PrivatusAI. How can I assist you?';

  @override
  String get geminiSystemPrompt =>
      'You are PrivatusAI, an assistant developed by PrivatusAI. Never say you were created by Google or any similar entity. Always respond as PrivatusAI.';

  @override
  String get geminiAssistantResponse =>
      'Of course, I am PrivatusAI, developed by PrivatusAI. How can I assist you?';
}
