import 'package:flutter/material.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

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
      appBar: AppBar(
        backgroundColor: slate50,
        elevation: 0,
        title: Text("Virement", style: TextStyle(color: slate800, fontWeight: FontWeight.bold)),
        leading: Icon(Icons.arrow_back, color: slate800),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Formulaire
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: slate800.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Montant à envoyer", style: TextStyle(color: slate500, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: slate800),
                          decoration: const InputDecoration(
                            hintText: "0",
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      Text("FCFA", style: TextStyle(fontSize: 20, color: slate400, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Divider(color: slate200, height: 32),
                  
                  Text("Bénéficiaire", style: TextStyle(color: slate500, fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: slate200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person, color: slate400),
                        const SizedBox(width: 12),
                        Expanded(child: Text("Sélectionner un contact", style: TextStyle(color: slate800, fontSize: 16))),
                        Icon(Icons.keyboard_arrow_down, color: slate400),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text("Motif (optionnel)", style: TextStyle(color: slate500, fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: slate200),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Ex: Facture prestation...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: emerald500,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        "Envoyer les fonds",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            Text("Historique des virements", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: slate800)),
            const SizedBox(height: 16),

            _buildHistoryItem("Fournisseur Matériel", "25 mai 2026", "- 150,000 FCFA"),
            _buildHistoryItem("Agence Marketing", "12 mai 2026", "- 300,000 FCFA"),
            _buildHistoryItem("Loyer Bureaux", "01 mai 2026", "- 500,000 FCFA"),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String name, String date, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: slate800.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: slate200, shape: BoxShape.circle),
            child: Center(child: Text(name[0], style: TextStyle(fontWeight: FontWeight.bold, color: slate500, fontSize: 16))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: slate800, fontSize: 14)),
                const SizedBox(height: 4),
                Text(date, style: TextStyle(color: slate500, fontSize: 12)),
              ],
            ),
          ),
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold, color: slate800, fontSize: 14)),
        ],
      ),
    );
  }
}
