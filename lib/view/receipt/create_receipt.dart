// ignore_for_file: depend_on_referenced_packages, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:migo/layout/layout.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/view/receipt/receipt_layout_widget.dart';
import 'package:migo/widgets/billing_page_divider.dart';
import 'package:migo/widgets/charts/receipt_sceen.dart';
import 'package:migo/utils/custome_drive.dart';
// import 'package:migo/models/product/product_model.dart';
import 'package:migo/models/receipt/receipt_model.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';


class CreateReceipt extends StatefulWidget {
  const CreateReceipt({super.key});

  @override
  State<CreateReceipt> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<CreateReceipt> {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      activeTab: 1,
      pageName: "Management Reçu",
      content: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(!Responsive.isMobile(context) ? 0 : 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BillingPageDivider(),
              const SizedBox(height: 32),
              // const Text("Gestion d'un reçu",
              //     style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
              // const SizedBox(height: 8),
              const ManagenentReceipt(),
            ],
          ),
        ),
      ),
    );
  }
}





class ManagenentReceipt extends StatelessWidget {
  const ManagenentReceipt({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: !Responsive.isMobile(context)
          ? MediaQuery.of(context).size.width - 90
          : MediaQuery.of(context).size.width,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 36,
        children: [
          const SizedBox(width: 20),
          const CustomersInfos(),
          if (Responsive.isMobile(context)) Center(
            child:CustomersInfos(),
          ),

          const SizedBox(width: 39),
          const ProductInfos(),
          if (Responsive.isMobile(context)) Center(
            child:ProductInfos(),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10), // Ajoute 20 pixels d'espace
            child: const ReceiptInfos(),
          ),
          const SizedBox(width: 36),
          if (Responsive.isDesktop(context)) const ReceiptScreen(),
        ],
      ),
    );
  }
}

class CustomersInfos extends StatelessWidget {
  const CustomersInfos({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: !Responsive.isMobile(context)
          ? (MediaQuery.of(context).size.width - 100) / 2.15
          : MediaQuery.of(context).size.width - 25,
      height: !Responsive.isMobile(context)? 400 : 450,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 6, // Effet élevé pour le conteneur
          intensity: 0.8,
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
          color: Colors.white, // Garde la couleur neutre pour ton design
          shadowLightColor: Colors.white, // Lumière douce
          shadowDarkColor: Colors.grey.shade500, // Ombre externe
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
                    "Customer Infos",
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
                    depth: 6, // Léger effet de relief pour le bouton
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

class ProductInfos extends StatelessWidget {
  const ProductInfos({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: !Responsive.isMobile(context)
          ? (MediaQuery.of(context).size.width - 100) / 2.15
          : MediaQuery.of(context).size.width - 25,
      height: !Responsive.isMobile(context)? 400 : 380,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 6, // Effet élevé pour le conteneur
          intensity: 0.8,
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
          color: Colors.white, // Garde la couleur neutre pour ton design
          shadowLightColor: Colors.white, // Lumière douce
          shadowDarkColor: Colors.grey.shade500, // Ombre externe
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
                        Iconsax.box,
                        size: 20,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Products Infos",
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
                  depth: -5, // Effet intérieur concave
                  intensity: 0.6,
                  shape: NeumorphicShape.concave,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Désignation",
                    hintStyle: TextStyle(color: Color(0xFF7717E8)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Neumorphic(
                style: NeumorphicStyle(
                  depth: -5, // Effet intérieur concave
                  intensity: 0.6,
                  shape: NeumorphicShape.concave,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Quantité",
                    hintStyle: TextStyle(color: Color(0xFF7717E8)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Neumorphic(
                style: NeumorphicStyle(
                  depth: -5, // Effet intérieur concave
                  intensity: 0.6,
                  shape: NeumorphicShape.concave,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Prix Unitaire",
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
                    depth: 6, // Léger effet de relief pour le bouton
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add),
                      const SizedBox(width: 8),
                      const Text("Ajouter"),
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

// class ReceiptInfos extends StatelessWidget {
//   const ReceiptInfos({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: !Responsive.isMobile(context)
//           ? (MediaQuery.of(context).size.width) / 1.7
//           : MediaQuery.of(context).size.width - 16,
//       height: 970,
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                         color: const Color.fromARGB(152, 121, 23, 232),
//                         borderRadius: BorderRadius.circular(16)),
//                     child: const Icon(
//                       Iconsax.receipt_1,
//                       size: 20,
//                       color: Color(0xFFFFFFFF),
//                     ),
//                   ),
//                   const SizedBox(width: 10), 
//                   const Text(
//                     "Receipt Infos",
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ] 
//               ),
//               const SizedBox(height: 12), // un petit espace au-dessus du trait
//               CustomDivider(),
//               const SizedBox(height: 30),
//               ReceiptLayout(
//                 receiptNumber: 'R0001',
//                 dateTime: DateTime.now(),
//                 clientName: 'Dupont Jean',
//                 products: [
//                   Product(designation: 'Produit A', unitPrice: 1500, quantity: 7, amount: 10500),
//                   // ...
//                 ],
//                 totalInWords: 'Cent francs',
//                 paid: 80.0,
//                 due: 20.0,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


class ReceiptInfos extends StatefulWidget {
  const ReceiptInfos({Key? key}) : super(key: key);

  @override
  State<ReceiptInfos> createState() => _ReceiptInfosState();
}

class _ReceiptInfosState extends State<ReceiptInfos> {
  late Receipt? _receipt;
  late bool _isLoading;
  late String _errorMessage;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _errorMessage = '';
    _loadReceiptData();
  }

  Future<void> _loadReceiptData() async {
    try {
      // Simulation de réponse JSON
      final mockJsonResponse = {
        "receiptNumber": "REC-2025-045",
        "dateTime": "2023-10-25T14:45:00Z",
        "clientName": "Dupont Jean",
        "produits": [
          {
            "designation": "Produit A",
            "unitPrice": 1500,
            "quantity": 7,
            "amount": 10500
          },
          {
            "designation": "Produit A",
            "unitPrice": 1500,
            "quantity": 7,
            "amount": 10500
          },
          {
            "designation": "Produit A",
            "unitPrice": 1500,
            "quantity": 7,
            "amount": 10500
          },
          {
            "designation": "Produit A",
            "unitPrice": 1500,
            "quantity": 7,
            "amount": 10500
          },
          {
            "designation": "Produit A",
            "unitPrice": 1500,
            "quantity": 7,
            "amount": 10500
          },
          {
            "designation": "Produit A",
            "unitPrice": 1500,
            "quantity": 7,
            "amount": 10500
          },
          {
            "designation": "Produit A",
            "unitPrice": 1500,
            "quantity": 7,
            "amount": 10500
          },
          {
            "designation": "Produit A",
            "unitPrice": 1500,
            "quantity": 7,
            "amount": 10500
          },
          {
            "designation": "Produit A",
            "unitPrice": 1500,
            "quantity": 7,
            "amount": 10500
          },
          {
            "designation": "Produit A",
            "unitPrice": 1500,
            "quantity": 7,
            "amount": 10500
          },
          {
            "designation": "Produit A",
            "unitPrice": 1500,
            "quantity": 7,
            "amount": 10500
          },
          {
            "designation": "Produit A",
            "unitPrice": 1500,
            "quantity": 7,
            "amount": 10500
          },
          {
            "designation": "Produit B", 
            "unitPrice": 2500,
            "quantity": 3,
            "amount": 7500
          },
          {
            "designation": "Produit C", 
            "unitPrice": 2500,
            "quantity": 3,
            "amount": 7500
          },
          {
            "designation": "Produit D", 
            "unitPrice": 2500,
            "quantity": 3,
            "amount": 7500
          },
          {
            "designation": "Produit E", 
            "unitPrice": 2500,
            "quantity": 3,
            "amount": 7500
          }
        ],
        "total": 18000,
        "totalInWords": "Dix-huit mille",
        "paid": 15000,
        "due": 3000,
        "companyName": "Ma Société",
        "nif": "NIF-123-456",
        "rccm": "RCCM-2023-789",
        "address": "123 Rue Principale",
        "contact": "+227 90 00 00 00",
        "nomCaissier": "Jean CAISSIER"
      };

      // Simulation de délai réseau
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _receipt = Receipt.fromMap(mockJsonResponse);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de chargement des données: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: !Responsive.isMobile(context)
          ? (MediaQuery.of(context).size.width) / 2
          : MediaQuery.of(context).size.width - 16,
      height: 970,
      child: Center( // Assure le centrage du Neumorphic
        child: Neumorphic(
          style: NeumorphicStyle(
            depth: -10, // Effet concave interne plus prononcé
            intensity: 0.7, // Intensité modérée pour un bel effet
            shape: NeumorphicShape.concave, // Forme concave pour l'intérieur
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)), // Coins arrondis
            color: Colors.white, // Conserve la couleur originale
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildContent(), // Garde ton contenu existant
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 12),
        const CustomDivider(),
        const SizedBox(height: 30),
        ReceiptLayout(receipt: _receipt!),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
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
          "Informations du reçu",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
