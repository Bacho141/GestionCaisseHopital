// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:get/get.dart';
import 'package:migo/controller/invoice_controller.dart';
import 'package:migo/layout/layout.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/widgets/management_agents.dart';
import 'package:migo/utils/custome_drive.dart';
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


class Addagent extends StatelessWidget {
  const Addagent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: !Responsive.isMobile(context)
          ? (MediaQuery.of(context).size.width - 100) / 2.7
          : MediaQuery.of(context).size.width - 25,
      height: !Responsive.isMobile(context)? 500 : 480,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 10, // Effet élevé pour le conteneur
          intensity: 0.8,
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
          color: Colors.white, // Garde la couleur neutre pour ton design
          // shadowLightColor: Colors.white, // Lumière douce
          // shadowDarkColor: Colors.grey.shade500, // Ombre externe
          shadowLightColor: Colors.grey.shade200, // Lumière en haut/gauche
          shadowDarkColor: Colors.grey.shade600,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Neumorphic(
                    style: NeumorphicStyle(
                      depth: 4, // Effet de relief pour l'icône
                      intensity: 0.8,
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.circle(),
                      color: const Color.fromARGB(152, 121, 23, 232), // Conserve la couleur originale
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.person,
                        size: 20,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Ajouter un Agent",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomDivider(),
              const SizedBox(height: 30),
              // Formulaire avec effet intérieur concave
              Neumorphic(
                style: NeumorphicStyle(
                  depth: -4, // Effet intérieur concave
                  intensity: 0.6,
                  shape: NeumorphicShape.flat,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Name",
                    hintStyle: TextStyle(color: Color(0xFF7717E8)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Neumorphic(
                style: NeumorphicStyle(
                  depth: -4, // Effet intérieur concave
                  intensity: 0.6,
                  shape: NeumorphicShape.flat,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "First Name",
                    hintStyle: TextStyle(color: Color(0xFF7717E8)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Neumorphic(
                style: NeumorphicStyle(
                  depth: -4, // Effet intérieur concave
                  intensity: 0.6,
                  shape: NeumorphicShape.flat,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Address",
                    hintStyle: TextStyle(color: Color(0xFF7717E8)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Neumorphic(
                style: NeumorphicStyle(
                  depth: -4, // Effet intérieur concave
                  intensity: 0.6,
                  shape: NeumorphicShape.flat,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  color: Colors.white,
                ),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Phone",
                    hintStyle: TextStyle(color: Color(0xFF7717E8)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: NeumorphicButton(
                  onPressed: () {
                    // Action à faire lors de l'envoi
                  },
                  style: NeumorphicStyle(
                    depth: 8, // Ajoute un léger effet de relief
                    intensity: 0.7,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.send),
                      const SizedBox(width: 8),
                      const Text("Enregistré"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

