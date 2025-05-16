import 'package:flutter/material.dart';
// import 'package:migo/utils/number_to_words_fr.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/models/receipt/receipt_model.dart';

class ReceiptLayout extends StatefulWidget {
  final Receipt receipt;

  const ReceiptLayout({
    Key? key,
    required this.receipt,
  }) : super(key: key);

  @override
  State<ReceiptLayout> createState() => _ReceiptLayoutState();
}

class _ReceiptLayoutState extends State<ReceiptLayout> {
  // 1. Création d'un ScrollController
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose(); // Nettoyage obligatoire
    super.dispose();
  }

    // final total = receipt.produits.fold(0.0, (sum, p) => sum + p.amount);
    
  @override
  Widget build(BuildContext context) {
    var paid = widget.receipt.paid;
    var due = widget.receipt.due;

    Widget paymentSection(BuildContext context) {
      if (Responsive.isMobile(context)) {
        // Mobile : colonne
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Montant payé + champ
            Text('Montant payé : $paid'),
            const SizedBox(height: 10),
            FractionallySizedBox(
              widthFactor: 1,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Saisir montant payé',
                  border: const OutlineInputBorder(),
                  isDense: true,
                  suffixIcon: InkWell(
                    onTap: () {
                      // TODO : valider la valeur saisie
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200, // fond léger
                        shape: BoxShape.circle, // forme ronde
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 20, // taille réduite
                        color: Color(0xFF7717E8), // couleur d’accent
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Reste à payer + champ
            Text('Reste à payer : $due'),
            const SizedBox(height: 10),
            FractionallySizedBox(
              widthFactor: 1,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Saisir montant payé',
                  border: const OutlineInputBorder(),
                  isDense: true,
                  suffixIcon: InkWell(
                    onTap: () {
                      // TODO : valider la valeur saisie
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200, // fond léger
                        shape: BoxShape.circle, // forme ronde
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 20, // taille réduite
                        color: Color(0xFF7717E8), // couleur d’accent
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        // Desktop : ligne
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Montant payé : $paid'),
                  const SizedBox(height: 10),
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Saisir montant payé',
                        border: const OutlineInputBorder(),
                        isDense: true,
                        suffixIcon: InkWell(
                          onTap: () {
                            // TODO : valider la valeur saisie
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200, // fond léger
                              shape: BoxShape.circle, // forme ronde
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 20, // taille réduite
                              color: Color(0xFF7717E8), // couleur d’accent
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Reste à payer : $due'),
                  const SizedBox(height: 10),
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Saisir reste à payé',
                        border: const OutlineInputBorder(),
                        isDense: true,
                        suffixIcon: InkWell(
                          onTap: () {
                            // TODO : valider la valeur saisie
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200, // fond léger
                              shape: BoxShape.circle, // forme ronde
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 20, // taille réduite
                              color: Color(0xFF7717E8), // couleur d’accent
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // En-tête société dynamique
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/company_logo.png',
                  fit: BoxFit.contain,
                  height: 80,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.receipt.companyName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('NIF: ${widget.receipt.nif}'),
                    Text('RCCM: ${widget.receipt.rccm}'),
                    Text('Adresse: ${widget.receipt.address}'),
                    Text('Contact: ${widget.receipt.contact}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 2),
          const SizedBox(height: 8),
          // Section dynamique
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reçu No: ${widget.receipt.receiptNumber}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Date: ${_formatDateTime(widget.receipt.dateTime)}'),
            ],
          ),
          const SizedBox(height: 8),
          Text('Client: ${widget.receipt.clientName}',
              style: const TextStyle(fontSize: 16)),
          _buildResponsiveTable(context),
          const SizedBox(height: 16),
          Text(
            'Arrêté le présent reçu à la somme de : ${widget.receipt.totalInWords} Franc CFA',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 16),
          paymentSection(context),
          // Footer avec nom du caissier
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('${widget.receipt.nomCaissier}\nLe Caissier',
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  static String _formatDateTime(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }

  double _calculateTotal() {
    return widget.receipt.produits.fold(0, (sum, p) => sum + p.amount);
  }

  Widget _buildProductsTable() {
      return ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 300, // Hauteur maximale avant scroll
          minHeight: 100, // Hauteur minimale
        ),
        child: Scrollbar(
        // thumbVisibility: true,
        child: SingleChildScrollView(
          // ← et on s’assure aussi qu’il l’utilise
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: Table(
            border: TableBorder.all(color: Colors.grey),
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(2),
            },
              children: [
                // En-tête
                const TableRow(
                  decoration: BoxDecoration(color: Colors.grey),
                  children: [
                    _TableHeaderCell("Désignation"),
                    _TableHeaderCell("P.U"),
                    _TableHeaderCell("Qté"),
                    _TableHeaderCell("Montant"),
                  ],
                ),
                // Lignes dynamiques
                ...widget.receipt.produits.map((produit) => TableRow(
                      children: [
                        _TableCell(produit.designation),
                        _TableCell("${produit.unitPrice} F"),
                        _TableCell(produit.quantity.toString()),
                        _TableCell("${produit.amount} F"),
                      ],
                    )),
                // Total
                TableRow(
                  children: [
                    const _TableCell("Total", isHeader: true),
                    const _TableCell("-"),
                    const _TableCell("-"),
                    _TableCell("${_calculateTotal()} F", isHeader: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

  Widget _buildMobileScroll() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
      child: _buildProductsTable(),
    );
  }

  Widget _buildDesktopScroll() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 400),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: _buildProductsTable(),
        ),
      ),
    );

     
  }

  Widget _buildResponsiveTable(BuildContext context) {
    return Responsive.isMobile(context) 
        ? _buildMobileScroll()
        : _buildDesktopScroll();
  }
}
class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;

  const _TableCell(
    this.text, {
    this.isHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.black : Colors.grey[700],
        ),
      ),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String text;

  const _TableHeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return _TableCell(
      text,
      isHeader: true,
    );
  }
}




// @override
    // Widget _scrollProductsTableMobil(BuildContext context) {
    //   if (Responsive.isMobile(context)) {
    //     // Mobile : colonne
    //     return LayoutBuilder(
    //       builder: (context, constraints) {
    //         return ConstrainedBox(
    //           constraints: BoxConstraints(
    //             maxHeight: constraints.maxHeight * 0.7, // 70% de l'écran
    //           ),
    //           child: Scrollbar(
    //             controller: _scrollController,
    //             thumbVisibility: true,
    //             child: SingleChildScrollView(
    //               controller: _scrollController,
    //               child: _buildProductsTable(),
    //             ),
    //           ),
    //         );
    //       },
    //     );
    //   } else {
    //     return ConstrainedBox(
    //       constraints: const BoxConstraints(maxHeight: 300),
    //       child: Scrollbar(
    //         controller: _scrollController, // Lien explicite
    //         thumbVisibility: true,
    //         child: SingleChildScrollView(
    //           controller: _scrollController, // Même controller
    //           scrollDirection: Axis.vertical,
    //           child: _buildProductsTable(),
    //         ),
    //       ),
    //     );
    //   }
    // }
