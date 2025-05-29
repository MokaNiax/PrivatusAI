import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:uuid/uuid.dart';
import 'package:privatusai/models/conversation.dart';
import 'package:privatusai/services/conversation_storage_service.dart';
import 'package:privatusai/widgets/custom_app_bar.dart';
import 'package:privatusai/services/ai_service.dart';
import 'package:privatusai/services/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:privatusai/l10n/app_localizations.dart';

class ConversationPage extends StatefulWidget {
  final String? conversationId;
  final String? conversationTitle;

  const ConversationPage({
    super.key,
    this.conversationId,
    this.conversationTitle,
  });

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Conversation> _conversations = [];
  Conversation? _currentConversation;
  final ConversationStorageService _storageService = ConversationStorageService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadConversations() async {
    _conversations = await _storageService.loadConversations();

    if (widget.conversationId != null) {
      _currentConversation = _conversations.firstWhere(
            (conv) => conv.id == widget.conversationId,
        orElse: () {
          final newConversation = Conversation(
            id: widget.conversationId!,
            title: widget.conversationTitle!,
            messages: [],
            createdAt: DateTime.now(),
          );
          _conversations.insert(0, newConversation);
          _storageService.saveConversations(_conversations);
          return newConversation;
        },
      );
    } else {
      _currentConversation = null;
    }
    setState(() {});
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final settingsService = Provider.of<SettingsService>(context, listen: false);
    final apiKey = settingsService.aiApiKey;
    final aiServiceType = settingsService.aiServiceType;
    final aiModel = settingsService.aiModel;
    final localizations = AppLocalizations.of(context)!;

    if (apiKey == null || apiKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.aiApiKeyNotSet),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String message = _messageController.text.trim();
    if (message.isEmpty) return;

    if (_currentConversation == null) {
      _currentConversation = Conversation(
        id: const Uuid().v4(),
        title: message.length > 20 ? '${message.substring(0, 20)}...' : message,
        messages: [],
        createdAt: DateTime.now(),
      );
      _conversations.insert(0, _currentConversation!);
    }

    setState(() {
      _currentConversation!.messages.add({'role': 'user', 'text': message});
      _messageController.clear();
    });

    _scrollToBottom();

    try {
      final aiService = AIService(apiKey: apiKey, aiServiceType: aiServiceType, aiModel: aiModel, context: context);
      final aiResponse = await aiService.getAIResponse(_currentConversation!.messages);

      setState(() {
        _currentConversation!.messages.add({'role': 'ai', 'text': aiResponse});
      });
    } catch (e) {
      setState(() {
        _currentConversation!.messages.add({'role': 'ai', 'text': '${localizations.aiErrorPrefix}: ${e.toString()}'});
      });
    } finally {
      await _storageService.saveConversations(_conversations);
      _scrollToBottom();
    }
  }

  void _renameConversation(Conversation conversation) async {
    final localizations = AppLocalizations.of(context)!;
    String? newTitle = await showDialog<String>(
      context: context,
      builder: (context) {
        final TextEditingController renameController =
        TextEditingController(text: conversation.title);
        return AlertDialog(
          title: Text(localizations.renameConversationTitle),
          content: TextField(
            controller: renameController,
            decoration: InputDecoration(labelText: localizations.newTitleLabel),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations.cancelButton),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, renameController.text),
              child: Text(localizations.renameButton),
            ),
          ],
        );
      },
    );

    if (newTitle != null && newTitle.isNotEmpty) {
      setState(() {
        conversation.title = newTitle;
      });
      await _storageService.saveConversations(_conversations);
    }
  }

  void _deleteConversation(Conversation conversation) async {
    final localizations = AppLocalizations.of(context)!;
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.deleteConversationTitle),
          content: Text(localizations.deleteConversationConfirm(conversation.title)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(localizations.cancelButton),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(localizations.deleteButton),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _conversations.remove(conversation);
        if (_currentConversation?.id == conversation.id) {
          _currentConversation = null;
        }
      });
      await _storageService.saveConversations(_conversations);
      if (_currentConversation == null) {
        Navigator.pop(context);
      }
    }
  }

  int _indexOfKey(Key key) {
    return _conversations.indexWhere((element) => ValueKey(element.id) == key);
  }

  void _showPromptSelectionDialog() {
    final theme = Theme.of(context);
    final settingsService = Provider.of<SettingsService>(context, listen: false);
    final localizations = AppLocalizations.of(context)!;
    TextEditingController promptController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
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
                    localizations.managePromptsTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Consumer<SettingsService>(
                      builder: (context, settings, child) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: settings.customPrompts.length,
                          itemBuilder: (context, index) {
                            final prompt = settings.customPrompts[index];
                            return ListTile(
                              title: Text(
                                prompt,
                                style: TextStyle(color: theme.colorScheme.onSurface),
                              ),
                              onTap: () {
                                _messageController.text = prompt;
                                Navigator.of(context).pop();
                                _messageFocusNode.requestFocus();
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                                    onPressed: () async {
                                      promptController.text = prompt;
                                      String? newPrompt = await showDialog<String>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(localizations.editPromptTitle),
                                          content: TextField(
                                            controller: promptController,
                                            decoration: InputDecoration(labelText: localizations.promptContentLabel),
                                          ),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(context), child: Text(localizations.cancelButton)),
                                            ElevatedButton(onPressed: () => Navigator.pop(context, promptController.text), child: Text(localizations.saveButton)),
                                          ],
                                        ),
                                      );
                                      if (newPrompt != null && newPrompt.isNotEmpty && newPrompt != prompt) {
                                        settingsService.updateCustomPrompt(index, newPrompt);
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red.withOpacity(0.8)),
                                    onPressed: () {
                                      settingsService.removeCustomPrompt(index);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      promptController.clear();
                      String? newPrompt = await showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(localizations.addNewPromptTitle),
                          content: TextField(
                            controller: promptController,
                            decoration: InputDecoration(labelText: localizations.promptContentLabel),
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: Text(localizations.cancelButton)),
                            ElevatedButton(onPressed: () => Navigator.pop(context, promptController.text), child: Text(localizations.addButton)),
                          ],
                        ),
                      );
                      if (newPrompt != null && newPrompt.isNotEmpty) {
                        settingsService.addCustomPrompt(newPrompt);
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: Text(localizations.addNewPromptButton),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme.colorScheme.onPrimary,
                      backgroundColor: theme.colorScheme.primary,
                      minimumSize: const Size.fromHeight(40),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: _currentConversation?.title ?? localizations.newConversationTitle,
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      drawer: _buildDrawer(context),
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
          Column(
            children: [
              Expanded(
                child: _currentConversation == null || _currentConversation!.messages.isEmpty
                    ? Center(
                  child: Text(
                    localizations.startChattingPrompt,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
                    : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: kToolbarHeight + 20.0, bottom: 8.0),
                  itemCount: _currentConversation!.messages.length,
                  itemBuilder: (context, index) {
                    final message = _currentConversation!.messages[index];
                    final bool isUser = message['role'] == 'user';
                    final String messageText = message['text'] ?? '';

                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? theme.colorScheme.primary.withOpacity(0.8)
                                  : theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                color: isUser
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface.withOpacity(0.2),
                              ),
                            ),
                            child: SelectableText(
                              messageText,
                              style: TextStyle(
                                color: isUser
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (!isUser)
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, bottom: 8.0),
                              child: IconButton(
                                icon: Icon(Icons.copy, size: 20, color: theme.colorScheme.onBackground.withOpacity(0.6)),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: messageText));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(localizations.messageCopied, style: TextStyle(color: theme.colorScheme.onPrimary)),
                                    ),
                                  );
                                },
                                tooltip: localizations.copyMessageTooltip,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.construction, color: theme.colorScheme.onBackground),
                      onPressed: _showPromptSelectionDialog,
                      tooltip: localizations.selectPromptTooltip,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        focusNode: _messageFocusNode,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: localizations.sendMessageHint,
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        onSubmitted: (value) {
                          if (!HardwareKeyboard.instance.isShiftPressed) {
                            _sendMessage();
                          }
                        },
                        onTap: () {
                          if (HardwareKeyboard.instance.isShiftPressed) {
                            _messageFocusNode.requestFocus();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    FloatingActionButton(
                      onPressed: _sendMessage,
                      mini: true,
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      child: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void deactivate() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.deactivate();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (HardwareKeyboard.instance.isShiftPressed) {
        return false;
      } else {
        if (_messageFocusNode.hasFocus) {
          _sendMessage();
          return true;
        }
      }
    }
    return false;
  }


  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                localizations.conversationsTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ReorderableListView(
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final Conversation item = _conversations.removeAt(oldIndex);
                  _conversations.insert(newIndex, item);
                  _storageService.saveConversations(_conversations);
                });
              },
              children: _conversations.map((conversation) {
                return Dismissible(
                  key: ValueKey(conversation.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _deleteConversation(conversation);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    key: ValueKey(conversation.id),
                    title: Text(
                      conversation.title,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    selected: _currentConversation?.id == conversation.id,
                    selectedTileColor: theme.colorScheme.primary.withOpacity(0.2),
                    onTap: () {
                      setState(() {
                        _currentConversation = conversation;
                        Navigator.of(context).pop();
                      });
                      _scrollToBottom();
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _renameConversation(conversation),
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        ReorderableDragStartListener(
                          index: _indexOfKey(ValueKey(conversation.id)),
                          child: const Icon(Icons.drag_handle),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConversationPage(
                      conversationId: const Uuid().v4(),
                      conversationTitle: localizations.newConversationTitle,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_comment),
              label: Text(localizations.newConversationButton),
              style: ElevatedButton.styleFrom(
                foregroundColor: theme.colorScheme.onPrimary,
                backgroundColor: theme.colorScheme.primary,
                minimumSize: const Size.fromHeight(40),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}