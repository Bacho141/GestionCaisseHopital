import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:migo/models/receipt/receipt_model.dart';
// import 'package:migo/utils/number_to_words_fr.dart';
import 'package:migo/models/product/product_model.dart';

class POSReceipt extends StatelessWidget {
  final Receipt receipt;

  const POSReceipt({
    super.key,
    required this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    // final montantEnLettres = NumberToWordsFR.convert(receipt.total.toInt());

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
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text('Patient: ${receipt.clientName}'),
          ),
          
          _buildTable(receipt.produits, receipt.total),
          
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
        ],
      ),
    );
  }

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


    Widget _buildTable(List<Product> products,  double total) {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(140), // Désignation
        1: FixedColumnWidth(50),  // PU
        2: FixedColumnWidth(40),  // Qté
        3: FixedColumnWidth(60),  // Montant
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
          _buildTableCell(product.designation),
          _buildTableCell(product.unitPrice.toStringAsFixed(0)),
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

