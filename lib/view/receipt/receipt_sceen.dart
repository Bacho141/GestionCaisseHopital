import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:migo/controller/receipt_controller.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/view/receipt/receipt_layout_pos.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  // Déclarez jsonResponse comme variable d'instance
  final ReceiptController receiptCtrl = Get.find<ReceiptController>();

  
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final receipt = receiptCtrl.currentReceipt.value;
      // if (receipt == null) {
      //   return Center(child: Text('Aucun reçu en cours'));
      // }
      if (receipt == null) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // Adaptation selon l'écran
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.receipt_long,
                  size: 50,
                  color: Colors.grey,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Aucun reçu en cours',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ajoutez un patient pour commencer.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      }

      // on reprend votre layout existant
      return SizedBox(
        width: !Responsive.isMobile(context)
            ? (MediaQuery.of(context).size.width - 500) / 2.3
            : MediaQuery.of(context).size.width - 16,
        height: 950,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  POSReceipt(receipt: receipt),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

}
