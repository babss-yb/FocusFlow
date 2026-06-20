import 'package:flutter/material.dart';

class ProfileReferralScreen extends StatelessWidget {
  const ProfileReferralScreen({super.key});

  final slate50 = const Color(0xFFF8FAFC);
  final slate200 = const Color(0xFFE2E8F0);
  final slate400 = const Color(0xFF94A3B8);
  final slate500 = const Color(0xFF64748B);
  final slate800 = const Color(0xFF1E293B);
  final emerald100 = const Color(0xFFD1FAE5);
  final emerald300 = const Color(0xFF6EE7B7);
  final emerald500 = const Color(0xFF10B981);
  final emerald600 = const Color(0xFF059669);
  final emerald700 = const Color(0xFF047857);
  final emerald800 = const Color(0xFF065F46);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: slate50,
      appBar: AppBar(
        backgroundColor: slate50,
        elevation: 0,
        title: Text("Mon Profil", style: TextStyle(color: slate800, fontWeight: FontWeight.bold)),
        leading: Icon(Icons.arrow_back, color: slate800),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // Parrainage
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: emerald100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: emerald300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Programme Ambassadeur", style: TextStyle(color: emerald800, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          "Invitez d'autres entrepreneurs et gagnez des récompenses business (mois offerts, accès premium).",
                          style: TextStyle(color: emerald700, fontSize: 13, height: 1.4),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: emerald600,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text("Partager mon lien", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.card_giftcard, size: 64, color: emerald500),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Infos
            Text("Informations personnelles", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: slate800)),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: slate800.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                children: [
                  _buildEditField("Nom complet", "Samba Diallo"),
                  Divider(color: slate200, height: 32),
                  _buildEditField("Numéro de téléphone", "+221 77 123 45 67"),
                  Divider(color: slate200, height: 32),
                  _buildEditField("Email", "contact@entreprise.sn"),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Settings
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: slate800.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                children: [
                  _buildSettingsRow(Icons.business, "Détails de l'entreprise"),
                  Divider(color: slate200, height: 32),
                  _buildSettingsRow(Icons.security, "Sécurité & Mot de passe"),
                  Divider(color: slate200, height: 32),
                  _buildSettingsRow(Icons.support_agent, "Contacter le support"),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: slate400, fontSize: 13)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(color: slate800, fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Icon(Icons.edit, color: slate400, size: 20),
      ],
    );
  }

  Widget _buildSettingsRow(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: slate500),
        const SizedBox(width: 16),
        Expanded(child: Text(title, style: TextStyle(color: slate800, fontSize: 15, fontWeight: FontWeight.w600))),
        Icon(Icons.chevron_right, color: slate400),
      ],
    );
  }
}
