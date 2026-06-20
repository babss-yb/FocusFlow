import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/chat_message.dart';

/// Assistant IA comptable pour PME - Livrable 5.
/// Interface de chat simulant un assistant intelligent.
class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;

  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '0',
      content:
          'Bonjour ! 👋 Je suis votre assistant IA comptable, spécialisé dans l\'accompagnement des PME en Afrique de l\'Ouest.\n\nComment puis-je vous aider aujourd\'hui ?',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  // Réponses IA simulées
  final Map<String, String> _mockResponses = {
    'tva': '📊 **TVA au Sénégal**\n\nLe taux normal de TVA au Sénégal est de **18%**. Il s\'applique à la majorité des biens et services.\n\nVotre entreprise doit collecter la TVA dès que votre chiffre d\'affaires annuel dépasse **50 millions de FCFA**.\n\nVoulez-vous que je vous aide à calculer la TVA sur une facture ?',
    'facture': '📄 **Éléments obligatoires d\'une facture**\n\n1. Nom et adresse de votre entreprise\n2. NINEA (Numéro d\'identification)\n3. Numéro de facture séquentiel\n4. Date d\'émission\n5. Description des biens/services\n6. Montant HT et TTC\n7. Taux de TVA appliqué\n8. Coordonnées du client\n\nVoulez-vous que je vous génère un modèle de facture ?',
    'impot': '🏛️ **Obligations fiscales PME**\n\nEn tant que SARL, vos principales obligations sont :\n\n• **IS** : Impôt sur les sociétés à 30%\n• **TVA** : Déclaration mensuelle (18%)\n• **CFCE** : Contribution forfaitaire\n• **Retenue à la source** : Sur les salaires\n\nLes déclarations mensuelles doivent être déposées avant le **15 du mois suivant**.',
    'salaire': '💰 **Charges patronales au Sénégal**\n\nPour un salaire brut, les charges patronales sont :\n\n• **IPRES** (retraite) : 8.4%\n• **CSS** (sécurité sociale) : 7%\n• **IPM** (maladie) : ~3,700 FCFA/mois\n• **Accident du travail** : 1% à 5%\n\n📌 Pour un salaire brut de 350,000 FCFA, les charges patronales représentent environ **65,000 FCFA**.',
    'default': '🤔 C\'est une excellente question ! Voici ce que je peux vous dire :\n\nPour vous fournir une réponse précise et adaptée à votre situation, je vous recommande de :\n\n1. Consulter votre comptable agréé\n2. Vérifier les réglementations locales (OHADA)\n3. Contacter votre centre des impôts\n\nY a-t-il autre chose sur laquelle je peux vous aider ?',
  };

  final List<String> _quickQuestions = [
    '💼 Taux de TVA au Sénégal ?',
    '📄 Éléments d\'une facture',
    '🏛️ Obligations fiscales PME',
    '💰 Charges patronales',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simule la réponse IA avec un délai
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          final lowerText = text.toLowerCase();
          String response;

          if (lowerText.contains('tva')) {
            response = _mockResponses['tva']!;
          } else if (lowerText.contains('facture')) {
            response = _mockResponses['facture']!;
          } else if (lowerText.contains('impot') ||
              lowerText.contains('impôt') ||
              lowerText.contains('fiscal')) {
            response = _mockResponses['impot']!;
          } else if (lowerText.contains('salaire') ||
              lowerText.contains('charge') ||
              lowerText.contains('patronal')) {
            response = _mockResponses['salaire']!;
          } else {
            response = _mockResponses['default']!;
          }

          _messages.add(ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: response,
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // En-tête
            _buildChatHeader(isDark),

            // Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                  vertical: AppTheme.spacingSm,
                ),
                itemCount: _messages.length +
                    (_isTyping ? 1 : 0) +
                    (_messages.length == 1 ? 1 : 0),
                itemBuilder: (context, index) {
                  // Questions rapides (affichées après le premier message)
                  if (_messages.length == 1 && index == 1) {
                    return _buildQuickQuestions(isDark);
                  }

                  // Indicateur de frappe
                  if (_isTyping && index == _messages.length + (_messages.length == 1 ? 1 : 0)) {
                    return _buildTypingIndicator(isDark);
                  }

                  final msgIndex = _messages.length == 1 && index > 0
                      ? index - 1
                      : index;
                  if (msgIndex >= _messages.length) {
                    return _buildTypingIndicator(isDark);
                  }

                  return _buildMessageBubble(
                      _messages[msgIndex], isDark);
                },
              ),
            ),

            // Zone de saisie
            _buildInputArea(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildChatHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 24),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assistant IA Comptable',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimaryLight,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.accentGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'En ligne',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(ChatMessage(
                  id: '0',
                  content:
                      'Conversation réinitialisée ! 🔄\n\nComment puis-je vous aider ?',
                  isUser: false,
                  timestamp: DateTime.now(),
                ));
              });
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Nouvelle conversation',
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  const Icon(Icons.smart_toy, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppTheme.primaryColor
                    : (isDark ? AppTheme.cardDark : AppTheme.scaffoldLight),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(AppTheme.radiusMd),
                  topRight: const Radius.circular(AppTheme.radiusMd),
                  bottomLeft: Radius.circular(
                      message.isUser ? AppTheme.radiusMd : 4),
                  bottomRight: Radius.circular(
                      message.isUser ? 4 : AppTheme.radiusMd),
                ),
                border: message.isUser
                    ? null
                    : Border.all(
                        color: isDark
                            ? AppTheme.dividerDark
                            : AppTheme.dividerLight,
                      ),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: message.isUser
                      ? Colors.white
                      : (isDark
                          ? AppTheme.textPrimaryDark
                          : AppTheme.textPrimaryLight),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildQuickQuestions(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _quickQuestions.map((q) {
          return GestureDetector(
            onTap: () => _sendMessage(q),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
                borderRadius:
                    BorderRadius.circular(AppTheme.radiusRound),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                q,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Icon(Icons.smart_toy, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.cardDark : AppTheme.scaffoldLight,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 600 + (index * 200)),
                  builder: (context, value, child) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primaryColor
                            .withOpacity(0.3 + (value * 0.5)),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.cardDark : AppTheme.scaffoldLight,
                  borderRadius: BorderRadius.circular(AppTheme.radiusRound),
                  border: Border.all(
                    color:
                        isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Posez votre question...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        onSubmitted: _sendMessage,
                        textInputAction: TextInputAction.send,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.attach_file, size: 20),
                      color: isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => _sendMessage(_messageController.text),
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
