// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:get/get.dart';
import 'package:migo/controller/invoice_controller.dart';
import 'package:migo/layout/layout.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/view/agents/add_agent.dart';
import 'package:migo/widgets/management_agents.dart';
// import 'package:migo/view/agents/management_agents.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';


class Agents extends StatefulWidget {
  const Agents({super.key});

  @override
  State<Agents> createState() => _Agents();
}

class _Agents extends State<Agents> {
  final InvoiceController invoiceController = Get.put(InvoiceController());
  
  @override
  void initState() {
    super.initState();
    invoiceController.fetchAllInvoice();
  }
  
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      activeTab: 0,
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              if (!Responsive.isMobile(context))
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Addagent(),
                    ManagementAgents(),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child:Addagent(),
                    ),
                    const SizedBox(height: 16),
                    ManagementAgents(),
                  ],
                ),
            ],
          ),
        ),
      ),
      pageName: "Management Agents",
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

