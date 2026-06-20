import 'package:flutter/material.dart';
import 'home_shell_vx.dart';

class ActivationChecklistScreen extends StatelessWidget {
  const ActivationChecklistScreen({super.key});

  final slate50 = const Color(0xFFF8FAFC);
  final slate200 = const Color(0xFFE2E8F0);
  final slate400 = const Color(0xFF94A3B8);
  final slate500 = const Color(0xFF64748B);
  final slate800 = const Color(0xFF1E293B);
  final emerald500 = const Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: slate50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Icon(Icons.check_circle, color: emerald500, size: 80),
              const SizedBox(height: 24),
              Text(
                "Félicitations !",
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: slate800),
              ),
              const SizedBox(height: 8),
              Text(
                "Votre compte pro est maintenant actif.",
                style: TextStyle(fontSize: 16, color: slate500),
              ),
              const SizedBox(height: 48),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Prochaines étapes",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: slate800),
                ),
              ),
              const SizedBox(height: 20),

              _buildItem("Compte validé", isDone: true),
              const SizedBox(height: 12),
              _buildItem("IBAN généré", isDone: true),
              const SizedBox(height: 12),
              _buildItem("Effectuer le premier dépôt", isDone: false),
              const SizedBox(height: 12),
              _buildItem("Commander la carte physique", isDone: false),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeShellVx()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: slate800,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Accéder à mon tableau de bord",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String title, {required bool isDone}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDone ? emerald500 : slate200, width: 1.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDone ? emerald500 : slate200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDone ? Icons.check : Icons.hourglass_empty,
              color: isDone ? Colors.white : slate400,
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isDone ? slate800 : slate500,
                fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
