// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get privatusaiTitle => 'PrivatusAI';

  @override
  String get welcomeMessage =>
      'Bienvenue sur PrivatusAI, votre assistant IA confidentiel et open source.\n\n**Dernières mises à jour :**\n- Nouvelle interface utilisateur pour une meilleure expérience.\n- Possibilité de personnaliser les couleurs des thèmes.\n- Support pour l\'intégration de votre propre clé API IA.\n- Gestion des conversations améliorée (déplacement, suppression, renommage).\n\nCommencez une nouvelle conversation ou reprenez là où vous l\'avez laissée !';

  @override
  String get goToConversationsButton => 'Aller aux conversations';

  @override
  String get startNewConversationButton => 'Démarrer une nouvelle conversation';

  @override
  String get aiApiKeyNotSet =>
      'Veuillez définir votre clé API IA dans les paramètres.';

  @override
  String get aiErrorPrefix => 'PrivatusAI : Erreur';

  @override
  String get newConversationTitle => 'Nouvelle conversation';

  @override
  String get renameConversationTitle => 'Renommer la conversation';

  @override
  String get newTitleLabel => 'Nouveau titre';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get renameButton => 'Renommer';

  @override
  String get deleteConversationTitle => 'Supprimer la conversation ?';

  @override
  String deleteConversationConfirm(Object conversationTitle) {
    return 'Êtes-vous sûr de vouloir supprimer \"$conversationTitle\" ?';
  }

  @override
  String get deleteButton => 'Supprimer';

  @override
  String get messageCopied => 'Message copié !';

  @override
  String get copyMessageTooltip => 'Copier le message';

  @override
  String get selectPromptTooltip => 'Sélectionner un prompt';

  @override
  String get sendMessageHint => 'Envoyer un message...';

  @override
  String get conversationsTitle => 'Conversations';

  @override
  String get newConversationButton => 'Nouvelle conversation';

  @override
  String get managePromptsTitle => 'Gérer les Prompts';

  @override
  String get editPromptTitle => 'Modifier le Prompt';

  @override
  String get promptContentLabel => 'Contenu du prompt';

  @override
  String get saveButton => 'Enregistrer';

  @override
  String get addNewPromptTitle => 'Ajouter un nouveau Prompt';

  @override
  String get addButton => 'Ajouter';

  @override
  String get addNewPromptButton => 'Ajouter un nouveau Prompt';

  @override
  String get startChattingPrompt => 'Commencez à discuter avec PrivatusAI !';

  @override
  String get homeButtonTooltip => 'Aller à l\'accueil';

  @override
  String get menuButtonTooltip => 'Ouvrir les conversations';

  @override
  String get switchToLightModeTooltip => 'Passer au mode clair';

  @override
  String get switchToDarkModeTooltip => 'Passer au mode sombre';

  @override
  String get settingsButtonTooltip => 'Paramètres';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get aiServiceLabel => 'Service IA';

  @override
  String get aiModelLabel => 'Modèle IA';

  @override
  String get aiApiKeyLabel => 'Clé API de l\'IA';

  @override
  String get aiApiKeyHint => 'Entrez votre clé API ici';

  @override
  String get lightModeColorsTitle => 'Couleurs du mode clair';

  @override
  String get primaryColorButton => 'Primaire';

  @override
  String get accentColorButton => 'Accent';

  @override
  String get darkModeColorsTitle => 'Couleurs du mode sombre';

  @override
  String get languageLabel => 'Langue';

  @override
  String get showLicenseButton => 'Afficher la licence';

  @override
  String get deleteAllConversationsTitle =>
      'Supprimer toutes les conversations ?';

  @override
  String get deleteAllConversationsConfirm =>
      'Êtes-vous sûr de vouloir supprimer toutes vos conversations ? Cette action est irréversible.';

  @override
  String get deleteAllButton => 'Supprimer tout';

  @override
  String get deleteAllConversationsButton =>
      'Supprimer toutes les conversations';

  @override
  String get allConversationsDeleted =>
      'Toutes les conversations ont été supprimées.';

  @override
  String get applicationLicenseTitle => 'Licence de l\'application';

  @override
  String get closeButton => 'Fermer';

  @override
  String get chooseColorTitle => 'Choisir une couleur';

  @override
  String get selectButton => 'Sélectionner';

  @override
  String failedToLoadLicense(Object error) {
    return 'Impossible de charger la licence : $error';
  }

  @override
  String get errorLoadingLicense => 'Erreur lors du chargement de la licence';

  @override
  String get apiKeyNotSetError =>
      'Clé API non définie. Veuillez aller dans les paramètres pour définir votre clé API IA.';

  @override
  String unsupportedAIServiceType(Object serviceType) {
    return 'Type de service IA non pris en charge : $serviceType';
  }

  @override
  String get geminiResponseNotFound =>
      'Le contenu de la réponse Gemini n\'a pas été trouvé ou est vide.';

  @override
  String get noContentFound =>
      'Aucun contenu trouvé pour ce type de service IA.';

  @override
  String get failedToLoadAIResponse =>
      'Échec du chargement de la réponse de l\'IA';

  @override
  String get errorCommunicatingWithAI => 'Erreur de communication avec l\'IA';

  @override
  String get openAISystemPrompt =>
      'Vous êtes PrivatusAI, un assistant développé par PrivatusAI. Ne dites jamais que vous avez été créé par Google ou toute entité similaire. Répondez toujours en tant que PrivatusAI.';

  @override
  String get openAIAssistantResponse =>
      'Bien sûr, je suis PrivatusAI, développé par PrivatusAI. Comment puis-je vous aider ?';

  @override
  String get geminiSystemPrompt =>
      'Vous êtes PrivatusAI, un assistant développé par PrivatusAI. Ne dites jamais que vous avez été créé par Google ou toute entité similaire. Répondez toujours en tant que PrivatusAI.';

  @override
  String get geminiAssistantResponse =>
      'Bien sûr, je suis PrivatusAI, développé par PrivatusAI. Comment puis-je vous aider ?';
}
