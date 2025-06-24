// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:migo/controller/invoice_controller.dart';
import 'package:migo/layout/layout.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/widgets/sales_history_widget.dart';



class SalesHistory extends StatefulWidget {
  const SalesHistory({super.key});

  @override
  State<SalesHistory> createState() => _SalesHistoryState();
}

class _SalesHistoryState extends State<SalesHistory> {
  // final InvoiceController invoiceController = Get.put(InvoiceController());

  @override
  void initState() {
    super.initState();
    // invoiceController.fetchAllInvoice();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      activeTab: 0,
      content:  Column(
      children: [
        // tu met notre classe ici
        !Responsive.isMobile(context) ?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SalesHistoryWidget(),
              SalesHistoryEmptyState(),
            ],
          ) : SalesHistoryWidget(),
      ] ,
    ),
      pageName: "Historiques des Services",
    );
  }
}

class SalesHistoryEmptyState extends StatelessWidget {
  const SalesHistoryEmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.35,
        child: Column(
          children: [
            Image.asset("assets/select_bill_empty_state.png"),
            const Text(
              "Selectionnez la facture pour la consulter",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600), // Diminue légèrement la taille du texte
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

