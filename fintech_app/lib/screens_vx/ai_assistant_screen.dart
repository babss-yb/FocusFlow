import 'package:flutter/material.dart';

class AiAssistantScreen extends StatelessWidget {
  const AiAssistantScreen({super.key});

  final slate50 = const Color(0xFFF8FAFC);
  final slate200 = const Color(0xFFE2E8F0);
  final slate400 = const Color(0xFF94A3B8);
  final slate800 = const Color(0xFF1E293B);
  final emerald50 = const Color(0xFFECFDF5);
  final emerald200 = const Color(0xFFA7F3D0);
  final emerald500 = const Color(0xFF10B981);
  final emerald600 = const Color(0xFF059669);
  final emerald700 = const Color(0xFF047857);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: slate50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.smart_toy, color: emerald600),
            const SizedBox(width: 12),
            Text("Assistant Comptable IA", style: TextStyle(color: slate800, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: slate200, height: 1.0),
        ),
      ),
      body: Column(
        children: [
          // Chat area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildBotMsg("Bonjour ! Je suis votre assistant virtuel spécialisé en comptabilité et gestion. Comment puis-je vous aider aujourd'hui ?"),
                _buildUserMsg("Comment générer un export de mes factures du mois dernier pour mon expert-comptable ?"),
                _buildBotMsg("C'est très simple ! Je viens de générer un fichier PDF avec vos 14 factures de mai 2026. Voulez-vous que je vous l'envoie par email ?"),
              ],
            ),
          ),

          // Pills
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPill("Exporter mes relevés"),
                  _buildPill("Augmenter plafond carte"),
                  _buildPill("Où en est mon virement ?"),
                ],
              ),
            ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: slate800.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))
              ],
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: slate50,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: slate200),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Icon(Icons.attach_file, color: slate400),
                    ),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Posez votre question...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(4),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: emerald500, shape: BoxShape.circle),
                      child: const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotMsg(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, right: 32.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: emerald500, shape: BoxShape.circle),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: slate800.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))
                ],
              ),
              child: Text(text, style: TextStyle(color: slate800, height: 1.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserMsg(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, left: 48.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: emerald500,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: emerald500.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))
                ],
              ),
              child: Text(text, style: const TextStyle(color: Colors.white, height: 1.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: emerald50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: emerald200),
      ),
      child: Text(text, style: TextStyle(color: emerald700, fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }
}
