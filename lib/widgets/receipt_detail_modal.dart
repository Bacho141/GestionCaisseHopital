import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:migo/models/receipt/receipt_model.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/controller/receipt_controller.dart';
import 'package:migo/controller/controller_agent.dart';

class ReceiptDetailModal extends StatefulWidget {
  final Receipt receipt;
  final VoidCallback? onStatusChanged;

  const ReceiptDetailModal({
    Key? key,
    required this.receipt,
    this.onStatusChanged,
  }) : super(key: key);

  @override
  State<ReceiptDetailModal> createState() => _ReceiptDetailModalState();
}

class _ReceiptDetailModalState extends State<ReceiptDetailModal> {
  late String selectedStatus;
  bool isUpdating = false;
  final AgentController _agentCtrl = Get.find<AgentController>();

  @override
  void initState() {
    super.initState();

    // Vérification de la validité du reçu
    if (widget.receipt == null) {
      print('❌ Erreur: ReceiptDetailModal reçu avec un reçu null');
      return;
    }

    print(
        '✅ ReceiptDetailModal initialisé avec le reçu: ${widget.receipt.receiptNumber}');
    print('📊 Données du reçu:');
    print('   - Total: ${widget.receipt.total}');
    print('   - Paid: ${widget.receipt.paid}');
    print('   - Due: ${widget.receipt.due}');
    print(
        '   - Client: ${widget.receipt.client.firstname} ${widget.receipt.client.name}');
    print('   - Produits: ${widget.receipt.produits.length}');
    print('   - Caissier: ${widget.receipt.nomCaissier}');

    // Initialiser le statut actuel
    selectedStatus = widget.receipt.due > 0 ? 'due' : 'paid';
    print('🏷️ Statut initial: $selectedStatus');
  }

  /// Récupère le nom complet du caissier à partir de son ID ou nom
  String _getCaissierDisplayName() {
    final nomCaissier = widget.receipt.nomCaissier;

    // Si c'est déjà un nom complet (contient un espace), l'utiliser directement
    if (nomCaissier.contains(' ')) {
      return nomCaissier;
    }

    // Sinon, essayer de trouver l'agent par ID
    try {
      final agent = _agentCtrl.agents.firstWhere(
        (a) => a.id == nomCaissier,
      );

      return '${agent.prenom} ${agent.nom}';
    } catch (e) {
      print('⚠️ Agent non trouvé pour l\'ID: $nomCaissier');
      // Fallback: retourner le nomCaissier tel quel
      return nomCaissier;
    }
  }

  /// Met à jour le statut du reçu
  Future<void> _updateStatus() async {
    final currentStatus = widget.receipt.due > 0 ? 'due' : 'paid';
    if (selectedStatus == currentStatus) {
      print('ℹ️ Aucun changement de statut nécessaire');
      return; // Pas de changement
    }

    print('🔄 Mise à jour du statut de $currentStatus vers $selectedStatus');
    setState(() => isUpdating = true);

    try {
      final receiptController = Get.find<ReceiptController>();

      // Calculer les nouveaux montants
      double newPaid = selectedStatus == 'paid' ? widget.receipt.total : 0.0;
      double newDue = selectedStatus == 'paid' ? 0.0 : widget.receipt.total;

      print('📊 Calcul des nouveaux montants:');
      print('   - Total: ${widget.receipt.total}');
      print('   - Nouveau paid: $newPaid');
      print('   - Nouveau due: $newDue');

      // Appeler l'API pour mettre à jour le reçu
      final success = await receiptController.updateReceiptStatus(
        widget.receipt.receiptNumber,
        newPaid,
        newDue,
      );

      if (success) {
        print('✅ Mise à jour réussie');
        // Mettre à jour le reçu local
        widget.receipt.paid = newPaid;
        widget.receipt.due = newDue;

        Get.snackbar(
          'Succès',
          'Statut mis à jour avec succès',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );

        // Notifier le parent pour rafraîchir la liste
        widget.onStatusChanged?.call();

        // Fermer le modal après un délai
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      } else {
        print('❌ Échec de la mise à jour');
        Get.snackbar(
          'Erreur',
          'Impossible de mettre à jour le statut. Veuillez réessayer.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      print('❌ Exception lors de la mise à jour: $e');
      Get.snackbar(
        'Erreur',
        'Erreur lors de la mise à jour: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    } finally {
      if (mounted) {
        setState(() => isUpdating = false);
      }
    }
  }

  /// Formate un montant avec la devise
  String _formatAmount(double amount) {
    return '${NumberFormat('#,##0', 'fr_FR').format(amount)} FCFA';
  }

  /// Formate la date
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm', 'fr_FR').format(date);
  }

  /// Widget pour le badge de statut
  Widget _buildStatusBadge() {
    final isPaid = widget.receipt.due == 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPaid ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPaid ? 'Payé' : 'En attente',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: isMobile ? screenWidth * 0.95 : screenWidth * 0.7,
        height: isMobile ? screenHeight * 0.9 : screenHeight * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec titre et bouton fermer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Détails du reçu',
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Contenu scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Informations générales
                    _buildSection(
                      title: 'Informations générales',
                      icon: Icons.receipt,
                      children: [
                        _buildInfoRow(
                            'N° de reçu', widget.receipt.receiptNumber),
                        _buildInfoRow('Date et heure',
                            _formatDate(widget.receipt.dateTime)),
                        _buildInfoRow('Caissier', _getCaissierDisplayName()),
                        _buildInfoRow('Statut', '',
                            customWidget: _buildStatusBadge()),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Section Informations client
                    _buildSection(
                      title: 'Informations client',
                      icon: Icons.person,
                      children: [
                        _buildInfoRow('Nom complet',
                            '${widget.receipt.client.firstname} ${widget.receipt.client.name}'),
                        _buildInfoRow('Téléphone', widget.receipt.client.phone),
                        _buildInfoRow('Adresse', widget.receipt.client.address),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Section Produits/Services
                    _buildSection(
                      title: 'Produits et services',
                      icon: Icons.shopping_cart,
                      children: [
                        // Vérification des produits
                        if (widget.receipt.produits.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Aucun produit ou service associé à ce reçu',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        else ...[
                          // En-tête du tableau
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text('Service',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    child: Text('Prix unit.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    child: Text('Qté',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    child: Text('Total',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Liste des produits
                          ...widget.receipt.produits
                              .map((product) => Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            product.label,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                              _formatAmount(product.tarif)),
                                        ),
                                        Expanded(
                                          child:
                                              Text(product.quantity.toString()),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _formatAmount(product.amount),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ],
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Section Totaux
                    _buildSection(
                      title: 'Totaux',
                      icon: Icons.calculate,
                      children: [
                        _buildInfoRow('Montant total',
                            _formatAmount(widget.receipt.total)),
                        _buildInfoRow(
                            'Montant payé', _formatAmount(widget.receipt.paid)),
                        _buildInfoRow(
                            'Reste à payer', _formatAmount(widget.receipt.due)),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Text(
                            'Montant en lettres: ${widget.receipt.totalInWords}',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Section Modification du statut
                    _buildSection(
                      title: 'Modifier le statut',
                      icon: Icons.edit,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: selectedStatus,
                                decoration: const InputDecoration(
                                  labelText: 'Statut',
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'paid',
                                    child: Text('Payé'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'due',
                                    child: Text('En attente'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedStatus = value!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: isUpdating ? null : _updateStatus,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              child: isUpdating
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Text('Mettre à jour'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget pour créer une section
  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  /// Widget pour créer une ligne d'information
  Widget _buildInfoRow(String label, String value, {Widget? customWidget}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: customWidget ??
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
          ),
        ],
      ),
    );
  }
}
