import 'package:flutter/material.dart';
import 'activation_checklist_screen.dart';

class KycRegistrationScreen extends StatelessWidget {
  const KycRegistrationScreen({super.key});

  // Palette Tailwind
  final slate50 = const Color(0xFFF8FAFC);
  final slate200 = const Color(0xFFE2E8F0);
  final slate400 = const Color(0xFF94A3B8);
  final slate500 = const Color(0xFF64748B);
  final slate800 = const Color(0xFF1E293B);
  final emerald50 = const Color(0xFFECFDF5);
  final emerald400 = const Color(0xFF34D399);
  final emerald500 = const Color(0xFF10B981);
  final emerald600 = const Color(0xFF059669);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: slate50,
      appBar: AppBar(
        backgroundColor: slate50,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: slate800),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ouverture de compte PME",
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: slate800),
            ),
            const SizedBox(height: 8),
            Text(
              "Étape 2/3 : Informations légales",
              style: TextStyle(fontSize: 16, color: slate500),
            ),
            const SizedBox(height: 32),

            // Barre de progression
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                        color: emerald500, borderRadius: BorderRadius.circular(3)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                        color: emerald500, borderRadius: BorderRadius.circular(3)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                        color: slate200, borderRadius: BorderRadius.circular(3)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Champs de texte
            _buildField("Nom de l'entreprise", Icons.business),
            const SizedBox(height: 16),
            _buildField("Email professionnel", Icons.email_outlined),
            const SizedBox(height: 16),
            _buildField("Numéro de téléphone", Icons.phone_outlined),
            const SizedBox(height: 16),
            _buildField("Mot de passe", Icons.lock_outline, isPassword: true),
            const SizedBox(height: 32),

            // Zone d'upload
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: emerald50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: emerald400, width: 2, style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  Icon(Icons.camera_alt_outlined, color: emerald600, size: 32),
                  const SizedBox(height: 12),
                  Text(
                    "Prenez en photo votre Kbis\net Pièce d'identité",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: emerald600, fontWeight: FontWeight.w600, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // CTA
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ActivationChecklistScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: emerald500,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Soumettre pour validation express (< 24h)",
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String hint, IconData icon, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: slate200),
      ),
      child: TextField(
        obscureText: isPassword,
        style: TextStyle(color: slate800),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: slate400),
          prefixIcon: Icon(icon, color: slate400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
