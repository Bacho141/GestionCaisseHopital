import 'package:get/get.dart';
import 'package:migo/controller/receipt_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:migo/models/receipt/receipt_model.dart';
import 'package:migo/models/receipt/receipt_cart_model.dart';
import 'package:migo/view/servicemedical/servicemedical_page.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:migo/service/printer_service.dart';

class POSReceipt extends StatelessWidget {
  final Receipt receipt;

  POSReceipt({
    super.key,
    required this.receipt,
  });
  final ReceiptController _receiptCtrl = Get.find<ReceiptController>();

  @override
  Widget build(BuildContext context) {
    // final montantEnLettres = NumberToWordsFR.convert(receipt.total.toInt());

    Future<void> _printReceiptPdf(Receipt r) async {
      final doc = pw.Document();

      // Reproduit ton layout POS en PDF
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.roll80, // largeur ticket POS

          build: (pw.Context ctx) {
            final ttf = pw.Font.helvetica(); // ou embed ta police monospace
            return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  // —— EN-TÊTE —————————————————————————————
                  pw.Center(
                    child: pw.Text(
                      r.companyName,
                      style: pw.TextStyle(
                          font: ttf,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Center(
                    child: pw.Text('NIF: ${r.nif} | RCCM: ${r.rccm}',
                        style: pw.TextStyle(font: ttf, fontSize: 8)),
                  ),
                  pw.Center(
                    child: pw.Text(r.address,
                        style: pw.TextStyle(font: ttf, fontSize: 8)),
                  ),
                  pw.Center(
                    child: pw.Text('Tél: ${r.contact}',
                        style: pw.TextStyle(font: ttf, fontSize: 8)),
                  ),
                  pw.Divider(height: 1, thickness: 1),

                  // —— INFOS GÉNÉRALES ——————————————————————
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Reçu n°: ${r.receiptNumber}',
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                      pw.Text(DateFormat('dd/MM/yyyy HH:mm').format(r.dateTime),
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                    ],
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text('Patient: ${r.client.firstname} ${r.client.name}',
                      style: pw.TextStyle(font: ttf, fontSize: 8)),
                  pw.Divider(height: 1, thickness: 1),

                  // —— TABLEAU DES SERVICES ——————————————————
                  pw.Row(
                    children: [
                      pw.Expanded(
                          flex: 5,
                          child: pw.Text('Désignation',
                              style: pw.TextStyle(font: ttf, fontSize: 8))),
                      pw.Expanded(
                          flex: 2,
                          child: pw.Text('PU',
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(font: ttf, fontSize: 8))),
                      pw.Expanded(
                          flex: 2,
                          child: pw.Text('Qté',
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(font: ttf, fontSize: 8))),
                      pw.Expanded(
                          flex: 3,
                          child: pw.Text('Mt',
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(font: ttf, fontSize: 8))),
                    ],
                  ),
                  pw.Divider(height: 1, thickness: 0.5),
                  // Lignes dynamiques
                  ...r.produits.map((it) => pw.Row(
                        children: [
                          pw.Expanded(
                              flex: 5,
                              child: pw.Text(it.label,
                                  style: pw.TextStyle(font: ttf, fontSize: 8))),
                          pw.Expanded(
                              flex: 2,
                              child: pw.Text(it.tarif.toStringAsFixed(0),
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(font: ttf, fontSize: 8))),
                          pw.Expanded(
                              flex: 2,
                              child: pw.Text(it.quantity.toString(),
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(font: ttf, fontSize: 8))),
                          pw.Expanded(
                              flex: 3,
                              child: pw.Text(it.amount.toStringAsFixed(0),
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(font: ttf, fontSize: 8))),
                        ],
                      )),
                  pw.Divider(height: 1, thickness: 1),

                  // —— TOTALS ——————————————————————————————
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('TOTAL',
                          style: pw.TextStyle(
                              font: ttf,
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold)),
                      pw.Text(r.total.toStringAsFixed(0),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                              font: ttf,
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text('En lettres: ${r.totalInWords} FCFA',
                      style: pw.TextStyle(font: ttf, fontSize: 7)),
                  pw.SizedBox(height: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Payé',
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                      pw.Text(r.paid.toStringAsFixed(0),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Reste',
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                      pw.Text(r.due.toStringAsFixed(0),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(font: ttf, fontSize: 8)),
                    ],
                  ),
                  pw.Divider(height: 1, thickness: 1),

                  // —— PIED DE TICKET ————————————————————————
                  pw.SizedBox(height: 4),
                  pw.Center(
                    child: pw.Text('Merci pour votre confiance !',
                        style: pw.TextStyle(font: ttf, fontSize: 7)),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Center(
                    child: pw.Text('Caissier: ${r.nomCaissier}',
                        style: pw.TextStyle(font: ttf, fontSize: 7)),
                  ),
                ]);
          },
        ),
      );

      // 4. Lancer la preview/print
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
        name: 'reçu_${r.receiptNumber}.pdf',
      );
    }

    return Container(
      width: 320,
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSeparator('='),
          Text(
            receipt.companyName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('NIF: ${receipt.nif}'),
          Text('RCCM: ${receipt.rccm}'),
          Text(receipt.address),
          Text('Tél: ${receipt.contact}'),
          _buildSeparator('='),
          _buildRow([
            'Reçu n°: ${receipt.receiptNumber}',
            DateFormat('dd/MM/yyyy HH:mm').format(receipt.dateTime),
          ]),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                    'Patient : ${receipt.client.firstname} ${receipt.client.name}'),
              ),
            ],
          ),

          _buildTable(receipt.produits.cast<ReceiptItem>(), receipt.total),

          _buildSeparator('-'),
          Text('TOTAL: ${receipt.total.toStringAsFixed(0)} FCFA'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'Arrêté le présent reçu à la somme de :\n${receipt.totalInWords} FCFA',
              textAlign: TextAlign.center,
            ),
          ),
          _buildSeparator('-'),
          _buildRow([
            'Montant payé: ${receipt.paid.toStringAsFixed(0)} F',
            'Reste à payer: ${receipt.due.toStringAsFixed(0)} F',
          ]),
          _buildSeparator('='),
          const Text(
            'Merci pour votre confiance !\nCe reçu est valable comme justificatif',
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('${receipt.nomCaissier}\nLe Caissier',
                textAlign: TextAlign.center),
          ),
          _buildSeparator('='),

          // Spacer pour séparer du pied de reçu
          const SizedBox(height: 16),

          Obx(() {
            // Montre un loader ou le texte selon isCreating
            final creating = _receiptCtrl.isCreating.value;
            return ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                minimumSize: Size(double.infinity, 40),
              ),
              icon: creating
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.print),
              label: Text(
                creating ? 'Création en cours…' : 'Valider & Imprimer',
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: creating
                  ? null
                  : () async {
                      // 1) Lance la création
                      final success = await _receiptCtrl.createReceipt();

                      // 2. Récupérer la Receipt fraîchement sauvegardée
                      final saved = _receiptCtrl.currentReceipt.value;
                      print('▶ createReceipt() a renvoyé: success=$success');
                      print('▶ Receipt sauvegardée: ${saved?.receiptNumber}, id:${saved?.client.name}');

                      if (!success || saved == null) {
                        Get.snackbar(
                          'Erreur',
                          'Échec de création du reçu',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // 3. Passer à l’étape impression
                      //Il faut que je verifie le design de reçu le rendre dynamique et tester l'impression sur des imprimentes.
                      // _printReceiptPdf(saved);
                      handlePrintReceipt(context, receipt);

                      // 2) Feedback visuel
                      if (success) {
                        Get.snackbar(
                          'Succès',
                          'Reçu créé avec succès',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.withOpacity(0.8),
                          colorText: Colors.white,
                        );
                        // 3) Navigue vers historique
                        // Get.toNamed('/receipts-history');
                      } else {
                        Get.snackbar(
                          'Erreur',
                          'Echec de la création du reçu',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.withOpacity(0.8),
                          colorText: Colors.white,
                        );
                      }
                    },
            );
          }),
          const SizedBox(height: 8),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade600,
              minimumSize: Size(double.infinity, 40),
            ),
            icon: const Icon(Icons.settings, color: Colors.white),
            label: const Text('Actions Reçu',
                style: TextStyle(color: Colors.white)),
            onPressed: () => _showReceiptActionsDialog(context),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.bug_report),
            label: const Text('Mode Debug Impression Bluetooth'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () async {
              final device = await showBluetoothPrinterDialog(context);
              if (device != null) {
                print('✅ Appareil choisi : ${device.name} (${device.address})');
              } else {
                print('ℹ️ Aucune imprimante Bluetooth sélectionnée.');
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.bug_report),
            label: const Text('Mode Debug Impression USB'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () async {
              final device = await showUsbPrinterDialog(context);
              if (device != null) {
                print(
                    '✅ Appareil USB choisi : ${device.name} (${device.address})');
              } else {
                print('ℹ️ Aucune imprimante USB sélectionnée.');
              }
            },
          ),
        ],
      ),
    );
  }

  void _showReceiptActionsDialog(BuildContext context) {
    final rc = _receiptCtrl;
    final receipt = rc.currentReceipt.value!;
    final firstCtrl = TextEditingController(text: receipt.client.firstname);
    final nameCtrl = TextEditingController(text: receipt.client.name);
    final phoneCtrl = TextEditingController(text: receipt.client.phone);
    final addrCtrl = TextEditingController(text: receipt.client.address);
    final paidCtrl = TextEditingController(
        text: rc.currentReceipt.value!.paid.toStringAsFixed(0));
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        // StatefulBuilder expose LE setState à utiliser ci‐dessous
        return StatefulBuilder(
          builder: (BuildContext sbContext, StateSetter setState) {
            return Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: AlertDialog(
                    insetPadding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollable: true,
                    title: const Text('Actions sur le reçu'),
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // … ton formulaire patient …
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Infos sur Patient',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 8),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: firstCtrl,
                                    decoration: const InputDecoration(
                                        labelText: 'Prénom'),
                                    validator: (v) =>
                                        v!.isEmpty ? 'Requis' : null,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: nameCtrl,
                                    decoration:
                                        const InputDecoration(labelText: 'Nom'),
                                    validator: (v) =>
                                        v!.isEmpty ? 'Requis' : null,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: phoneCtrl,
                                    decoration: const InputDecoration(
                                        labelText: 'Téléphone'),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: addrCtrl,
                                    decoration: const InputDecoration(
                                        labelText: 'Adresse'),
                                  ),
                                ],
                              ),
                            ),

                            const Divider(height: 24),

                            // --- Liste des services ---
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Services ajoutés :',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 8),

                            // --- Bloc de debug simplifié ---
                            if (rc.cart.isEmpty) ...[
                              const SizedBox(
                                  height: 120,
                                  child: Center(
                                      child: Text('Aucun service ajouté'))),
                            ] else ...[
                              // On enlève la ListView, on utilise un Column
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: rc.cart.map((it) {
                                  return Card(
                                    elevation: 1,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(it.label,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          Text(
                                              '${it.quantity} x ${it.tarif.toStringAsFixed(0)}'),
                                          const SizedBox(width: 12),
                                          GestureDetector(
                                            onTap: () {
                                              print(
                                                  '▶ Suppression de service (debug)');
                                              rc.removeService(it);
                                              // On redessine la dialog pour retirer la carte correspondante
                                              setState(() {});
                                            },
                                            child: const Icon(Icons.delete,
                                                color: Colors.redAccent,
                                                size: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],

                            const Divider(height: 24),

                            // === Nouveau champ Montant payé ===
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Montant payé :',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: paidCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Montant payé',
                                prefixText: 'FCFA ',
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Requis';
                                final d = double.tryParse(v);
                                if (d == null) return 'Nombre invalide';
                                if (d < 0) return 'Doit être ≥ 0';
                                return null;
                              },
                            ),

                            const Divider(height: 24),

                            // === Bouton Ajouter un service ===
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text('Ajouter un service'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                Get.to(() => const ProductsPage());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Annuler'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // 1) Mise à jour du patient
                            rc.updateClient(
                              firstCtrl.text.trim(),
                              nameCtrl.text.trim(),
                              phoneCtrl.text.trim(),
                              addrCtrl.text.trim(),
                            );
                            // 2) Mise à jour du paid
                            final newPaid = double.parse(paidCtrl.text.trim());
                            rc.updatePaid(newPaid);
                            Navigator.of(dialogContext).pop();
                            Get.snackbar(
                              'Succès',
                              'Reçu mis à jour',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green.withOpacity(0.8),
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: const Text('Enregistrer'),
                      ),
                    ]),
              ),
            );
          },
        );
      },
    );
  }

  //Update Paie

  // Les méthodes _buildSeparator, _buildRow, _buildTable restent identiques
  // ...
  Widget _buildSeparator(String character) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(character * 42, textAlign: TextAlign.center),
    );
  }

  Widget _buildRow(List<String> texts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: texts.map((text) => Flexible(child: Text(text))).toList(),
    );
  }

  Widget _buildTable(List<ReceiptItem> products, double total) {
    print("List<Product> : $products");
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(140), // Désignation
        1: FixedColumnWidth(50), // PU
        2: FixedColumnWidth(40), // Qté
        3: FixedColumnWidth(60), // Montant
      },
      border: TableBorder(
        horizontalInside: BorderSide(color: Colors.black),
        top: BorderSide(color: Colors.black),
        bottom: BorderSide(color: Colors.black),
      ),
      children: [
        // En-tête tableau
        TableRow(children: [
          _buildTableCell('Désignation', isHeader: true),
          _buildTableCell('PU', isHeader: true),
          _buildTableCell('Qté', isHeader: true),
          _buildTableCell('Mt', isHeader: true),
        ]),
        // Lignes produits
        ...products.map((product) => TableRow(children: [
              _buildTableCell(product.label),
              _buildTableCell(product.tarif.toStringAsFixed(0)),
              _buildTableCell(product.quantity.toString()),
              _buildTableCell(product.amount.toStringAsFixed(0)),
            ])),
        // Ligne totale
        TableRow(children: [
          const TableCell(child: SizedBox.shrink()),
          const TableCell(child: SizedBox.shrink()),
          _buildTableCell('Total', isHeader: true),
          _buildTableCell(total.toStringAsFixed(0), isHeader: true),
        ]),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
