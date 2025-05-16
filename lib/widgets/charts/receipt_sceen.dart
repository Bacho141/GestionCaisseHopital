import 'package:flutter/material.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/view/receipt/receipt_layout_pos.dart';
import 'package:iconsax/iconsax.dart';
import 'package:migo/utils/custome_drive.dart';
import 'package:migo/models/receipt/receipt_model.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  // Déclarez jsonResponse comme variable d'instance
  late final Map<String, dynamic> _jsonResponse;

  @override
  void initState() {
    super.initState();
    // Initialisez dans initState()
    _jsonResponse = {
      "receiptNumber": "REC-2023-045",
      "dateTime": "2023-10-25T14:45:00Z",
      "clientName": "Fatima Moussa",
      "produits": [
        {
          "designation": "Consultation générale",
          "unitPrice": 15000,
          "quantity": 1,
          "amount": 15000
        },
        {
          "designation": "Amoxicilline 500mg",
          "unitPrice": 500,
          "quantity": 30,
          "amount": 15000
        }
      ],
      "total": 30000,
      "totalInWords": "Trente mille",
      "paid": 30000,
      "due": 0,
      "companyName": "HÔPITAL GENERAL DE KINSHASA",
      "nif": "A-12345678-X",
      "rccm": "CD/KIN/RCCM/23-A-123",
      "address": "123 Avenue de la Santé, Kinshasa",
      "contact": "+243 810 000 000",
      "nomCaissier": "Alice MBOYA"
    };
  }

  @override
  Widget build(BuildContext context) {
    final receipt = Receipt.fromMap(_jsonResponse);

    return SizedBox(
      width: !Responsive.isMobile(context)
          ? (MediaQuery.of(context).size.width - 500) / 2.3
          : MediaQuery.of(context).size.width - 16,
      height: 970,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(152, 121, 23, 232),
                      borderRadius: BorderRadius.circular(16)),
                  child: const Icon(
                    Iconsax.receipt_1,
                    size: 20,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Receipt POS Infos",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]),
              const SizedBox(height: 12), // un petit espace au-dessus du trait
              CustomDivider(),
              const SizedBox(height: 30),
              POSReceipt(receipt: receipt),
            ],
          ),
        ),
      ),
    );
  }
}
